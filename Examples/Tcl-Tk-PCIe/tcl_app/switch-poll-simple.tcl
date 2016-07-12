#!/usr/bin/tclsh
# =====================================================================
# Simple Tcl Program to Poll PCIe-Controlled Switches
# =====================================================================

set USAGE \
"Usage:	$argv0 <poll-msec> <path-prefix> <switch-letter> ...
 with	- <poll-msec> the polling intefrvall in milliseconds
        - <path-prefix> the prefix of the device file path name
        - <switch-letter> the switch selector (a single letter)
"

if {$argc < 3} {
	puts -nonewline stderr $USAGE; flush stderr; exit 1
}


set poll_msec [lindex $argv 0]
set path_prefix [lindex $argv 1]
set switch_list [lreplace $argv 0 1]

if {[catch {expr $poll_msec}] || $poll_msec < 3 || $poll_msec > 2000} {
	puts stderr "$argv0: requested poll interval ($poll_msec) not supported"
	exit 2
}

proc poll_switches {} {
	global argv0 path_prefix switch_state switch_list
	set result ""
	foreach sw $switch_list {
		set fn $path_prefix$sw
		if {[catch {open $fn} fh]} {
			puts stderr "$::argv0: cannot open file ($fn)"
			exit 3
		}
		append result [gets $fh]
		close $fh
	}
	return $result
}

set old_state [string repeat ? [llength $switch_list]]
while true {
	set new_state [poll_switches]
	if {![string equal $new_state $old_state]} {
		set now [expr {[clock microseconds] / 1e6}]
		puts [format {[%012.6f] (%s): %s  -->  %s}\
				$now\
				[join $switch_list ""]\
				[join [split $old_state ""] " | "]\
				[join [split $new_state ""] " | "]\
		]
		set old_state $new_state
	}
	after $poll_msec ;# is: sleep ...
}
