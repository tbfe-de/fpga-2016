#!/usr/bin/tclsh
# =============================================================================
# Step 9 - showing a "count-down" in Tk GUI on a "remote display"
# =============================================================================
#
# Change the "count-down" server to provide any number of a remote displays:
# - on the server side provide a "headless" Tcl program;
# - it should have the capability to send the GUI to the client.
#
source "step9_port.cfg"

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

proc do_countdown_step {} {
	incr ::countdown -1
	if {$::countdown >= 0} {	# not yet done ...
		update_remote_clients		;# ... let remotes know
		after 1000 do_countdown_step	;# ... start next round
	}
	if {$::countdown < 0} {		# completed ...
		 exit				;# ... finish program
	}
}

set client_code [format {
# :::::::::::::::: CLIENT GUI CODE (sent from server) ::::::::::::::::
#
  proc restart_countdown {} {
	if {[catch {
		puts $::server_fd "set ::countdown $::startvalue"
		puts $::server_fd "update_remote_clients"
	}]} {
		close $::server_fd
	}
  }

  button .restart\
	-text RESTART\
	-command restart_countdown
  label .countdown\
	-font {Sans 100}\
	-width %d\
	-textvariable countdown

  pack .countdown\
	-side top\
	-fill both\
	-expand 1
  pack .restart\
	-side bottom\
	-fill x
#
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
} [string length $::startvalue]
]

proc connect_remote_client {fd ip port} {
	set ip_port "$ip:$port"
	set ::remote_clients($fd) $ip_port

	# ininitalize the client with its GUI
	puts "accepted remote connection from $ip_port"
	puts $fd $::client_code; flush $fd

	# enable receiving commands from the client
	fileevent $fd readable [list accept_remote_command $fd]
	fconfigure $fd -buffering line

	# finally send these commands to the client
	puts $fd {fconfigure $::server_fd -buffering line}
	puts $fd [list set ::startvalue $::startvalue]
	puts $fd [list set ::countdown $::countdown]
	puts $fd {wm title . "Counting Down From $::startvalue"}
}

proc update_remote_clients {} {
	set clients [array names ::remote_clients]
	if {[set nclients [llength $clients]] > 0} {
		puts "updating $nclients client(s) with value $::countdown" 
	}
	foreach cl [array names ::remote_clients] {
		if {[catch {
			# be careful - the client might have gone(!)
			puts $cl [list set ::countdown $::countdown]
		}]} {
			catch {close $cl} 		;# maybe too careful?
			unset ::remote_clients($cl)	;# disconnect client
		}
	}
}

proc accept_remote_command {cl} {
	if {[eof $cl]
	 || [gets $cl part] < 0} {
		catch {close $cl}
		unset ::remote_clients($cl)
		return
	}
	puts "$::remote_clients($cl) sent cmd: $part"
	append ::script $part\n
	if {[info complete $::script]} {
		puts "executing cmd from $::remote_clients($cl)"
		uplevel #0 $::script	;# ok to trust, we sent the GUI
		unset ::script
	}
}

# getting ready for take-off
#
set countdown $startvalue
socket -server connect_remote_client $::PORT
after 1000 do_countdown_step

#####
vwait forever ;# because this is Tcl, NOT Tk !!
#####
