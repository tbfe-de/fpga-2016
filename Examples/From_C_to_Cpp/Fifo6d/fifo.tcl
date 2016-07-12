load ./fifo.so

set fifo [new_fifo_long_20]

proc fifo_empty {}      { $::fifo empty }
proc fifo_full {}       { $::fifo full }
proc fifo_size {}       { $::fifo size } 
proc fifo_put {payload} { $::fifo put $payload }

proc fifo_get {vpayload} {
	upvar $vpayload payload
        lassign [$::fifo get] ret payload
	return $ret
}
