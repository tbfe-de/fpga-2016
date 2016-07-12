#include "fifo.h"

int fifo_size(const fifo* f) {
	return (f->pslot >= f->gslot)
		? f->pslot - f->gslot
		: f->pslot + (fifo_MAXSIZE+1) - f->gslot;
}

bool fifo_put(fifo* f, const fifo_payload* pl) {
	if (fifo_full(f)) return false;
	f->storage[f->pslot] = *pl;
	f->pslot = fifo_slot_incr(f->pslot);
	return true;
}

bool fifo_get(fifo* f, fifo_payload *pl) {
	if (fifo_empty(f)) return false;
	*pl = f->storage[f->gslot];
	f->gslot = fifo_slot_incr(f->gslot);
	return true;
}
