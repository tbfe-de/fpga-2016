#!/usr/bin/tclsh
# =============================================================================
# Step 2 - printing the command line arguments
# =============================================================================
#
# Write a Tcl-Script that prints its own file name, followed by more command
# line arguments.
#
# The name of the script and each command line argument should go into a line
# of its own, and the command line arguments should be indented by an asterisc
# and a single space.
#
# If the above works, add a "Usage Help", i.e. make the scrinpt print  message
# telling its user that at least one command line argument should be provided.

if {?!? == 0} {
	puts stderr "(please provide at least one command line argument)"
	exit 1
}

puts ?!?			;# name of program
foreach arg ?!? {		;# loop over all arguments
	puts "* $arg"		;# print each indented by '* '
}
