#!/usr/bin/wish
# =============================================================================
# Step 8 - printing a "count-down" in Tk GUI and provide a "remote display"
# =============================================================================
#
# To the Tk-based GUI, add support for providing a remote display over a
# TCP/IP socket.
#
# Allow for multiple clients and care for some degree of robustness in case a
# client dies away while the server is still running
#
# Use a separate program (see Step 8x) to add an appriate client.

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
	incr ::countdown -1
	if {$::countdown >= 0} {		# not yet done ...
		?!?					;# ... let remotes know
	 	?!?					;# ... start next round
	}
	if {$::countdown < 0} {			# completed ...
		 ?!?					;# ... finish program
	}
}

proc restart_countdown {} {
	set ?!?
	update_remote_clients
}

proc update_remote_clients {} {
	foreach cl [array names ::remote_clients] {
		if {[catch {
			puts $cl $::countdown
		}]} {
			close $cl
			unset ?!?
		}
	}
}

proc connect_remote_client {fd ip port} {
	fconfigure $fd -buffering line
	set ::remote_clients($fd) "$ip:$port"
}

button .restart\
	-text RESTART\
	-background blue -foreground white\
	-command restart_countdown
label .countdown\
	-font {Sans 100}\
	-width [string length $startvalue]\
	-textvariable countdown

pack .countdown\
	-side top\
	-fill both\
	-expand 1
pack .restart\
	-side bottom\
	-fill x

set countdown $startvalue
socket -server connect_remote_client 49297 
after 1000 show_countdown_step
wm title ?!?

######
# NOTE: The EVENT-LOOP is AUTOMATICALLY entered in `wish` ("Tk Window Shell")
######
