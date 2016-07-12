#include "fifo.h"

template<typename PayLoad, int MaxSize>
int fifo<PayLoad, MaxSize>::size() {
	return (pslot >= gslot)
		? pslot - gslot
		: pslot + (MaxSize+1) - gslot;
}

template<typename PayLoad, int MaxSize>
bool fifo<PayLoad, MaxSize>::put(const PayLoad& pl) {
	if (full()) return false;
	storage[pslot] = pl;
	pslot = slot_incr(pslot);
	return true;
}

template<typename PayLoad, int MaxSize>
bool fifo<PayLoad, MaxSize>::get(PayLoad &pl) {
	if (empty()) return false;
	pl = storage[gslot];
	gslot = slot_incr(gslot);
	return true;
}

template<typename PayLoad, int MaxSize>
PayLoad fifo<PayLoad, MaxSize>::storage[MaxSize+1];

template<typename PayLoad, int MaxSize>
int fifo<PayLoad, MaxSize>::pslot = 0;

template<typename PayLoad, int MaxSize>
int fifo<PayLoad, MaxSize>::gslot = 0;

#ifndef SWIG
template class fifo<long, 20>;
#endif
