#ifndef FIFO_H
#define FIFO_H

#include <stdbool.h>

typedef long fifo_payload;

enum {fifo_MAXSIZE = 20};

typedef struct {
	int pslot;
	int gslot;
	fifo_payload storage[fifo_MAXSIZE+1];
} fifo;

inline
void fifo_init(fifo* f) {
	f->pslot = 0;
	f->gslot = 0;
}

inline
int fifo_slot_incr(int slot) {
	return (slot+1) % (fifo_MAXSIZE+1);
}

inline
bool fifo_empty(const fifo* f) {
	return (f->gslot == f->pslot);
}

inline
bool fifo_full(const fifo* f) {
	return (fifo_slot_incr(f->pslot) == f->gslot);
}

extern int fifo_size();

extern bool fifo_put(fifo* f, const fifo_payload* pl);
extern bool fifo_get(fifo* f, fifo_payload* pl);

#endif
