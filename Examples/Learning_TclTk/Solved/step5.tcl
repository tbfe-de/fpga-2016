#!/usr/bin/tclsh
# =============================================================================
# Step 5 - printing a "count-down" in a single line
# =============================================================================
#
# Change the Tcl script printing a countdown from 10 so that all the values
# (up to 0) go to the same line, separated by dashes surrounded with spaces.
#
# Use a subroutine taking the "channel" (as returned from `open`) as argument.
# The program should send its output to a file if has a command line (which
# then names the file) or to the console (when no command line argument is
# provided).

proc print_countdown {{chan stdout}} {
	for {set i 10} {$i >= 0} {incr i -1} { # loop from 10 down to 0
		puts -nonewline $chan $i 
		if {$i > 0} {			# not yet done ...
			puts -nonewline $chan " - "	;# ... print separator
			flush $chan			;# ... avoid buffering
			after 1000			;# ... and sleep 1 sec
		}
	}
	puts $chan ""; flush $chan	;# causes a new-line to be written
}

switch -exact $argc {
	0 {	# NO arguments habe been provided
		# (this is OK)
	}
	1 {	# exactly one argument has been provided
		set outfile_name [lindex $argv 0] 
	}
	default {
		# more than one argment has been provided
		puts stderr "Usage: $argv0 \[<outfile>\]" 
		exit 1
	}
}

if {[info exists outfile_name]} { # tests whether the variable(!) exists
	if {[catch { # test if the following fails or not ...
		open $outfile_name w
	} x]} { # ... we arrive here if an error has occured:
		set reason $x		;# in `x` we find the details
		puts stderr "$argv0: cannot open \"$outfile_name\": $reason"
		exit 2
	} else { # ... and here if file has been opened:
		set outfd $x		;# in `x` we find the channel
	}
}

if {[info exists outfd]} { # tests whether the variable(!) exists
	print_countdown $outfd	;# hand-over channel as argument ...
	close $outfd		;# ... and do not forget(!) to close it
} else {
	print_countdown		;# `stdout` is the default (see above)
}
