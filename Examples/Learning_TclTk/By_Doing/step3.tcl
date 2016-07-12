#!/usr/bin/tclsh
# =============================================================================
# Step 3 - printing a "count-down"
# =============================================================================
#
# Write a Tcl script that prints a count-down from a starting value supplied as
# (single and mandatory) command line argument. Each value should go to a line
# of its own that starts with a dash and a space.

if {$argc != 1} {
	puts stderr "Usage: $argv0 <startval>" 
	exit 1
}

set startval [lindex $argv 0]
if {![string is ?!? $startval]} {
	puts stderr "$argv: ERROR not an integral number: $startval" 
	exit 2
}

for {set i $startval} {$i >= 0} {?!?} {	# loop down to 0
	puts stdout "- $i"			;# print indented
	?!?					;# sleep 1000 msec
}
