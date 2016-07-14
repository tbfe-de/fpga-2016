#!/usr/bin/tclsh
# =====================================================================
# Tcl Program Implementing a TCP Server for Switching LEDs
# =====================================================================

set USAGE \
"Usage:	$argv0 \[<driver-sysfs> \[<led-prefix>\]]
 with	- <driver-sysfs> the directory path to the directory where
	  the led PCIe driver is located
        - <led-prefix> the prefix to the LED device files (for which
          a directly concatenated numeric extension is expected)
"

proc die {rcode {message usage} {detail {}}} {
	if {[string equal $message usage]} {
		puts -nonewline stderr $::USAGE
		flush stderr
		exit $rcode
	}
	if {[string length $detail] > 0} {
		set detail "($detail)"
	}
	puts stderr "$::argv0: $message $detail"
	flush stderr
	exit $rcode
}

switch -exact $argc {
      2	{}
      1	{ lappend argv LED }
      0	{ lappend argv /sys/tcl_drv LED }
default { die 1 }
}

set sys_fs_dir [lindex $argv 0]

if {![file isdirectory $sys_fs_dir]} {
	die 2 "invalid directory" $sys_fs_dir
}

set led_dev_prefix [lindex $argv 1]
if {[catch {
	lsort [glob -directory $sys_fs_dir $led_dev_prefix*]
   } led_dev_files]} {
	die 3 "cannot locate device files" "for $led_dev_prefix*"
}

array set led_state {}

proc show_led_states {} {
	puts "State of Connected LEDs:"
	foreach led [lsort [array names ::led_state]] {
		puts "$led is [lindex "off on" $::led_state($led)]"
	}
}

foreach led_dev $led_dev_files {
	set led_state($led_dev) 0
}

proc set_led {led state} {
	if {$::led_state($led) == $state} return
	catch {
		set fh [open $led w]
		catch {
			puts $fh [set $::led_state($led) $state]
		}
		close $fh
	}
	set ::led_state($led) $state
	show_led_states
}

array set clients {}

proc show_connections {} {
	puts -nonewline "Connected clients:"
	set n 0
	foreach {fd cl} [array get ::clients] {
		puts -nonewline [format "\n(%d) via %s: %s"\
				[incr n] $fd [join $cl { }]]
	}
	puts [lindex [list " currently none" ""] [expr {$n != 0}]] 
}

proc tcp_disconnect {fd} {
	puts "disconnecting $fd"
	catch {close $fd}
	array unset ::clients $fd
	show_connections
}

proc send_led_update {{skip_fd {}}} {
	foreach fd [array names ::clients] {
		if {[string equal $fd $skip_fd]} continue
		foreach {led state} [array get ::led_state] {
			puts $fd "$led=$state"
		}
		flush $fd
	}
}

proc tcp_listen {fd} {
	if {[eof $fd]
	 || [gets $fd led_set] < 0} {
		tcp_disconnect $fd
		return
	}
	if {![regexp {^(.*)=([01])$} $led_set - led state]} {
		puts "protocol violation from $fd"
		tcp_disconnect $fd
		return
	}
puts "client requested $led_set"
	set_led $led $state
	send_led_update
	
}

proc tcp_accept {fd ip port} {
	set now [clock seconds]
	set ip_port $ip:$port
	puts "accepting connection from $ip_port"
	puts $fd [lsort [array names ::led_state]]
	fileevent $fd readable [list tcp_listen $fd]
	set now_formatted [clock format $now -format "%Y-%m-%d %H:%M:%S"]
	set ::clients($fd) [list $ip_port $now_formatted]
	show_connections
	send_led_update
}

show_led_states
show_connections

socket -server tcp_accept 7243 ;# is PCIe on a phone dial

vwait forever
