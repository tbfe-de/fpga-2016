#!/usr/bin/tclsh
# =============================================================================
# Step 6 - printing a "count-down" in a single line
# =============================================================================
#
# Modify the Tcl script printing a countdown from 10 to an event-driven design.
#
# HINT: avoid a loop in the subroutine taking the "channel" argument. Instead
# make it call itself via the event loop-
# The program should send its output to a file if has a command line (which
# then names the file) or to the console (when no command line argument is
# provided).

proc print_countdown {i {chan stdout}} {
	puts -nonewline $chan $i 
	if {$i > 0} {				# not yet done ...
		puts -nonewline $chan " - "		;# ... print separator
		?!?					;# ... avoid buffering
		?!?				;# ... decrement `i`
		after 1000 [list\
			print_countdown $i $chan	;# start next round
		]
		return
	}
	?!?				;# cause a new-line to be written
	set ::stop 1			;# terminate explicit event loop
}

switch -exact $argc {
	0 {	# NO arguments habe been provided
		# (this is OK)
	}
	1 {	# exactly one argument has been provided
		set outfile_name ?!?
	}
	default {
		# more than one argment has been provided
		puts stderr "Usage: $argv0 \[<outfile>\]" 
		exit 1
	}
}

if {[info exists outfile_name]} { # tests whether the variable(!) exists
	if {[catch { # test if the following fails or not ...
		open $outfile_name  w
	} ?!?]} { # ... we arrive here if an error has occured:
		set reason $x		;# in `x` we find the details
		puts stderr "$argv0: cannot open \"$outfile_name\": $reason"
		exit 2
	} else { # ... and here if file has been opened:
		set outfd $x		;# in `x` we find the channel
	}
}

if {[info exists outfd]} { # tests whether the variable(!) exists
	print_countdown ?!?		;# hand-over channel as argument ...
	?!?				;# ... and do not forget to close it
} else {
	print_countdown	?!?		;# `stdout` is the default (see above)
	?!?				;# (anything forgotten here?)
}

vwait stop	;# any change to the value of `stop` ends the event loop
