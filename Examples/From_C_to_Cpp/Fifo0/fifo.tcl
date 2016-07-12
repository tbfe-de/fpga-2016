# ====================================================================
# Tcl Implementation of FIFO storage
# ====================================================================

set FIFO_MAXSIZE 20
set fifo_data [list]

proc fifo_empty {} {
	global fifo_data
	return [expr {[llength $fifo_data] == 0}]
}

proc fifo_full {} {
	global fifo_data
	global FIFO_MAXSIZE
	return [expr {[llength $fifo_data] >= $FIFO_MAXSIZE}]
}

proc fifo_size {} {
	global fifo_data
	return [llength $fifo_data]
}

proc fifo_put {payload} {
	global fifo_data
	if {![fifo_full]} {
		lappend fifo_data $payload
		return 1
	}
	return 0
}

proc fifo_get {vpayload} {
	global fifo_data
	upvar $vpayload payload
	if {![fifo_empty]} {
		set payload [lindex $::fifo_data 0]
		set ::fifo_data [lreplace $::fifo_data 0 0]
		return 1
	}
	return 0
}
