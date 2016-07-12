#include "fifo.h"

static fifo_payload fifo_storage[FIFO_MAXSIZE+1];

static int pslot = 0;
static int gslot = 0;

#if MACRO_FOR_SLOT_INCR
#define slot_incr(slot)\
	((slot+1) % (FIFO_MAXSIZE+1))
#else
static int slot_incr(int slot) {
	return (slot+1) % (FIFO_MAXSIZE+1);
}
#endif

int fifo_empty() {
	return (gslot == pslot);
}

int fifo_full() {
	return (slot_incr(pslot) == gslot);
}

int fifo_size() {
	return (pslot >= gslot)
                ? pslot - gslot
                : pslot + (FIFO_MAXSIZE+1) - gslot;
}

int fifo_put(const fifo_payload *ppl) {
	if (fifo_full()) return 0;
	fifo_storage[pslot] = *ppl;
	pslot = slot_incr(pslot);
	return 1;
}

int fifo_get(fifo_payload *ppl) {
	if (fifo_empty()) return 0;
	*ppl = fifo_storage[gslot];
	gslot = slot_incr(gslot);
	return 1;
}
