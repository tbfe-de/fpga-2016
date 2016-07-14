#!/usr/bin/wish
# =============================================================================
# Universal Tcl/Tk Remote Control Client (Configured by the Server)
# =============================================================================
#
set USAGE "$argv0 \[<host>\]:<port> \[debug\]"

# --------------------------------------------- get arguments from command line
#
proc split_server_port {server_port_arg vserver vport} {
	if {[llength [split $server_port_arg :]] != 2} {
		return 0
	}
	upvar $vserver server
	upvar $vport port
	lassign [split $server_port_arg :] server port
	if {![string is integer $port]
	 || $port < 1 || $port > 65534} {
puts ">$server< >$port<"
		return 0
	}
	if {[string equal $server ""]} {
		set server "localhost"
	}
	return 1
}

switch -exact $argc {
	1 {	# one argument has been provided
		set server_port [lindex $argv 0]
		set DEBUG 0
	}
	2 {	# two arguments have been provided
		set server_port [lindex $argv 0] 
		set opt_debug [lindex $argv 1]
		if {![string equal $opt_debug debug]} {
			puts stderr "$argv0: bad option ($opt_debug)"
			exit 2
		}
		set DEBUG 1
	}
	default {
		# more than two argment has been provided
		puts stderr "Usage: $USAGE"
		exit 1
	}
}

if {![split_server_port $server_port SERVER PORT]} {
	puts stderr "$argv0: illegal host/port: $server_port"
	exit 2
}

# ----------------------------------------- support some form of debug-traceing
#
proc show_received_commands {} {
	if {[winfo exists .received_commands]} return

	# create another top-level window
	toplevel .received_commands
	wm title .received_commands "Commands Received from $::SERVER:$::PORT"

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

set server_fd [socket $SERVER $PORT]			;# connect to server
fconfigure $server_fd -buffering line			;# send each line
fileevent $server_fd readable remote_server_receive	;# start receiving

wm title . "Remote Control for $SERVER:$PORT"

######
# NOTE: The EVENT-LOOP is AUTOMATICALLY entered in `wish` ("Tk Window Shell")
######
