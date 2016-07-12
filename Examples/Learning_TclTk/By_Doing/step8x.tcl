#!/usr/bin/wish
# =============================================================================
# Step 8x - a reomote display for the "count-down" server
# =============================================================================

switch -exact $argc {
	1 {	# exactly one argument has been provided
		set host [lindex $argv 0] 
	}
	default {
		# more than one argment has been provided
		puts stderr "Usage: $argv0 <host>"
		exit 1
	}
}

proc remote_server_receive {} {
	if {[eof $::server_fd]
	 || [gets $::server_fd val] < 0} {
		?!?
	}
	.received insert end $val\n
	.received see end
	set ?!? $val
}

set server_fd [socket ?!? 49297]
fileevent $server_fd readable remote_server_receive

label .countdown\
	-font {Sans 100}\
	-width 3\
	-textvariable countdown
text .received\
	-width 8 -height 10

bind .received <1>\
	[list .received delete 1.0 end]

pack .countdown\
	-side left\
	-fill ?!?
pack .received\
	-side right\
	-fill ?!?\
	-expand 1

wm title . "Count-Down Remote Display"

######
# NOTE: The EVENT-LOOP is AUTOMATICALLY entered in `wish` ("Tk Window Shell")
######
