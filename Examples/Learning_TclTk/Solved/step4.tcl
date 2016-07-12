#!/usr/bin/tclsh
# =============================================================================
# Step 4 - printing a "count-down"
# =============================================================================
#
# Change the Tcl script printing a countdown so that its output goes to the
# file `countdown.txt`. Run the program from the command line as a background
# job (or run it from a separate terminal) and watch the file while it grows
# with: `tail -f countdown.txt`

if {$argc != 1} {
	puts stderr "Usage: $argv0 <startval>" 
	exit 1
}

set startval [lindex $argv 0]
if {![string is integer $startval]} {
	puts stderr "$argv: ERROR not an integral number: $startval" 
	exit 2
}


set outfd [open countdown.txt w]
fconfigure $outfd -buffering line

for {set i $startval} {$i >= 0} {incr i -1} {	;# loop down to 0
	puts $outfd "- $i"			;# print indented
	after 1000				;# sleep 1000 msec
}

close $outfd
