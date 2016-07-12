#!/usr/bin/wish
# =============================================================================
# Step 9x - generic TK remote interface
# =============================================================================
#
source "step9_port.cfg"

# --------------------------------------------- get arguments from command line
#
switch -exact $argc {
	0 {	# no argument has been provided
		set HOST localhost
		set DEBUG 0
	}
	1 {	# one argument has been provided
		set HOST [lindex $argv 0] 
		set DEBUG 0
	}
	2 {	# two one argument has been provided
		set HOST [lindex $argv 0] 
		set opt_debug [lindex $argv 1]
		if {![string equal $opt_debug debug]} {
			puts stderr "$argv0: bad option ($opt_debug)"
			exit 2
		}
		set DEBUG 1
	}
	default {
		# more than two argment has been provided
		puts stderr "Usage: $argv0 \[<host>\] \[debug\]"
		exit 1
	}
}

# ----------------------------------------- support some form of debug-traceing
#
proc show_received_commands {} {
	if {[winfo exists .received_commands]} return

	# create another top-level window
	toplevel .received_commands
	wm title .received_commands "Commands Received from $::HOST:$::PORT"

	# create text widget and a scrollbar
	text .received_commands.t\
		-height 20 -width 80\
		-wrap word
	scrollbar .received_commands.sb\
		-orient vertical

	# bi-directionall wire the text widget with its scrollbar
	.received_commands.t configure\
		-yscrollcommand [list .received_commands.sb set]
	.received_commands.sb configure\
		-command [list .received_commands.t yview]

	# display text widget and scrollbar
	pack .received_commands.t\
		-side left -fill both -expand 1
	pack .received_commands.sb\
		-side right -fill y

	# defer output when mouse pointer is in the window
	bind .received_commands <Enter> {
		.received_commands.t configure -state disabled
	}
	bind .received_commands <Leave> {
		.received_commands.t configure -state normal
		if {[info exists ::receive_buffer]} {
			.received_commands.t insert end $::receive_buffer
			unset ::receive_buffer
		}
	}
}

if {$::DEBUG} show_received_commands		;# enable from start
bind . <Control-D> show_received_commands	;# enable at any time

# ---------------------- (very) generic interface for server to run ANY command
#
# *****************************************************************************
# ** For SECURITY REASONS, in an open network this kind of generic interface **
# ** should be protected by establishing some form of (mutual) trust !!!!!!! **
# *****************************************************************************
#
proc remote_server_receive {} {
	if {[eof $::server_fd]
	 || [gets $::server_fd part] < 0} {
		close $::server_fd
		exit
	}

	if {[winfo exists .received_commands]} { # the trace window is open
		switch -exact [.received_commands.t cget -state] {
			normal { # immediate trace output (see above)
				.received_commands.t insert end $part\n
				.received_commands.t see end
			}
			disabled { # deferred trace output (see above)
				append ::receive_buffer $part\n
			}
		}
	}

	append ::script $part\n
	if {[info complete $::script]} {
		uplevel #0 $::script
		unset ::script
	}
}

set server_fd [socket $::HOST $::PORT]			;# connect to server
fileevent $server_fd readable remote_server_receive	;# start receiving

######
# NOTE: The EVENT-LOOP is AUTOMATICALLY entered in `wish` ("Tk Window Shell")
######
