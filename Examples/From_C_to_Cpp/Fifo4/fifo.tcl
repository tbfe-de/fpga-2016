load ./fifo.so

rename fifo_get ns_fifo_get

proc fifo_get {vpayload} {
	upvar $vpayload payload
        lassign [ns_fifo_get] ret payload
	return $ret
}
