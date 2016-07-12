#include "fifo.h"

int fifo::size() {
	return (pslot >= gslot)
		? pslot - gslot
		: pslot + (MAXSIZE+1) - gslot;
}

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
