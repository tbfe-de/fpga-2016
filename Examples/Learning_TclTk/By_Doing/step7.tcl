#!/usr/bin/wish
# =============================================================================
# Step 7 - printing a "count-down" in Tk GUI
# =============================================================================
#
# Add a Tk-based GUI to the the Tcl script printing a countdown from 10.
# It should:
# - NOT any more accept a file name argument;
# - instead TAKE THE START VALUE from its command line argument
# - terminate when the value 0 is reached;
# - provide a button to RESTART the countdown.
#
# BE SURE TO UNDERSTAND that ONLY the event driven approach can be happily
# married with a TK GUI!

switch -exact $argc {
	1 {	# exactly one argument has been provided
		set startvalue [lindex $argv 0] 
	}
	default {
		# more than one argment has been provided
		puts stderr "Usage: $argv0 <startvalue>"
		exit 1
	}
}

proc show_countdown_step {} {
	if {[incr ::countdown -1] >= 0} {	# not yet done ...
		after ?!? 		 		;# ... start next round
	}
	if {$::countdown < 0} {			# completed ...
		 ?!?					;# ... finish program
	}
}

proc restart_countdown {} {
	set ::countdown $::startvalue
}

button .restart\
	-text RESTART\
	-background blue -foreground white\
	-command ?!?
label .countdown\
	-font {Sans 100}\
	-width 3\
	-textvariable ?!?

pack .countdown\
	-side ?!?\
	-fill both\
	-expand 1
pack .restart\
	-side ?!?\
	-fill x

set countdown ?!?
after 1000 show_countdown_step
wm title . "Counting down from ?!?"

######
# NOTE: The EVENT-LOOP is AUTOMATICALLY entered in `wish` ("Tk Window Shell")
######
