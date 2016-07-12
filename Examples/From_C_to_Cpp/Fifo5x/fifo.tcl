load ./fifo.so

set fifo [new_fifo]

rename fifo_empty c_fifo_empty
proc fifo_empty {}      { c_fifo_empty $::fifo }

rename fifo_full c_fifo_full
proc fifo_full {}       { c_fifo_full $::fifo }

rename fifo_size c_fifo_size
proc fifo_size {}       { c_fifo_size $::fifo } 

rename fifo_put c_fifo_put
proc fifo_put {payload} { c_fifo_put $::fifo $payload }

rename fifo_get c_fifo_get
proc fifo_get {vpayload} {
	upvar $vpayload payload
        lassign [c_fifo_get $::fifo] ret payload
	return $ret
}
