#!/usr/bin/tclsh
# =====================================================================
# Simple Tcl Program for Repeated Switching PCIe-Controlled LEDs
# =====================================================================

set USAGE \
"Usage:	$argv0 <pattern>:<msec> ... \[loop\]
 with	- <pattern> a sequence of exactly four characters '0' or '1',
          determining wheter LEDs 0 to 3 are lit or dark.
        - <msec> the time to display this pattern
        - `loop` repeat (endlessly) from start
"

set DRIVER_SYS_FS "/sys/tcl_drv/"

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

proc parse_actions {} {
	set result [list]
	foreach pm $::argv {
		if {![regexp {^([01]{4}):(\d+)$} $pm - p m]} {
			die 2 "invalid <pattern>:<msec> argument" $pm
		}
		lappend result $p $m
	}
	return $result
}

proc set_leds {pattern} {
	for {set i 0} {$i < [string length $pattern]} {incr i} {
		set led_driver_fname $::DRIVER_SYS_FS/LED$i
		set led_driver_onoff [string index $pattern $i]
		set led_driver_fh [open $led_driver_fname w]
		puts $led_driver_fh $led_driver_onoff
		flush $led_driver_fh
		close $led_driver_fh
	}
}

proc run_patterns {} {
	global action_list
	foreach {pattern msec} $action_list {
		set_leds $pattern
		after $msec ;# means: sleep $msec
	}
}

if {$argc == 0} {die 1}

set loop [string equal [lindex $argv end] loop]
if {$loop} {
	set argv [lreplace $argv end end]
}
set action_list [parse_actions]

if {[llength $argv] == 0} {
	die 2 "at least one <pattern>:<time> argument required to `loop`"
}

set first 1
while {$first || $loop} {
	run_patterns
	set first 0
}

