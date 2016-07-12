#include "fifo.h"

#define FIFO_INL_INCLUDED_FROM_H 0
#include "fifo.inl"
#undef FIFO_INL_INCLUDED_FROM_H

bool fifo::put(const payload& pl) {
	if (full()) return false;
	storage[pslot] = pl;
	pslot = slot_incr(pslot);
	return true;
}

bool fifo::get(payload &pl) {
	if (empty()) return false;
	pl = storage[gslot];
	gslot = slot_incr(gslot);
	return true;
}

fifo::payload fifo::storage[fifo::MAXSIZE+1];

int fifo::pslot = 0;
int fifo::gslot = 0;
