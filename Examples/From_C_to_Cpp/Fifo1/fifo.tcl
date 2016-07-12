load ./fifo.so

rename fifo_get c_fifo_get

proc fifo_get {vpayload} {
	upvar $vpayload payload
        lassign [c_fifo_get] ret payload
	return $ret
}
