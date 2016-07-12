load ./fifo.so

rename fifo_long_20_empty fifo_empty
rename fifo_long_20_full fifo_full
rename fifo_long_20_size fifo_size
rename fifo_long_20_put fifo_put

proc fifo_get {vpayload} {
	upvar $vpayload payload
        lassign [fifo_long_20_get] ret payload
	return $ret
}
