#!/usr/bin/wish
# =====================================================================
# Tcl/Tk Client to Connect to the Server for the PCIe-Controlled LEDs
# =====================================================================

set USAGE \
"Usage:	$argv0 \[<ip>\]:<port>
 with   - <ip> is the ip number of the server (default localhost)
          <port> is the port number at which it listens
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

set ip_port [join $argv {}]
switch -regexp -- $ip_port {
{^:\d+$} 	{set ip_port "localhost$ip_port"}
{^.+:\d+$}	{}
default { die 1 }
}

if {[catch {
	eval socket [split $ip_port :]
   } server_fh]} {
	die 2 "cannot connect to $ip_port" $server_fh
}

proc set_led {led} {
	if {[catch {
		puts $::server_fh "$led=$::led_state($led)"
		flush $::server_fh
	} reason]} {
		die 5 "server unreachable" $reason
	}
}

proc get_led_list {} {
	global server_fh
	if {[eof $server_fh]} {
		die 3 "server did not send led-list"
	}
	set led_list [gets $server_fh]
	if {[llength $led_list] == 0} {
		die 4 "server did send empty led-list"
	}
puts "LEDS: $led_list"
	set n 0
	foreach led $led_list {
		set ::led_state($led) 0
		checkbutton .cb_$n -text $led\
			-variable led_state($led)\
			-command [list set_led $led]
		pack .cb_$n -side top -fill x
		incr n
	}
	wm title . "... waiting for LED state ..."
	fileevent $server_fh readable get_led_update
}

proc get_led_update {} {
	global server_fh
	if {[eof $server_fh]} {
		foreach cb [winfo children .] {
			destroy $cb
		}
		pack [
			.button -text "Server Shut Down"\
				-background red\
				-command exit
		] -expand 1 -fill both
		close $server_fh
	}
	set update_cmd [gets $server_fh]
	if {![regexp {^([a-zA-Z0-9_/]+)=([01])$} $update_cmd - led state]} {
		die 127 "bad update command from server" $update_cmd
	}
	if {![info exists ::led_state($led)]} {
		die 127 "received update for unknown led" $led
	}
	set ::led_state($led) $state
	wm title . "Last Update from Remote"
}

fileevent $server_fh readable get_led_list

wm geometry . 300x120
wm title . "... trying to connect ..."

