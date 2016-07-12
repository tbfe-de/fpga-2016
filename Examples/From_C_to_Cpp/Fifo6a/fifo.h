#ifndef FIFO_H
#define FIFO_H

template<typename PayLoad, int MaxSize>
class fifo {
public:

	fifo() {}

	inline
	bool empty() {
		return (gslot == pslot);
	}

	inline
	bool full() {
		return (slot_incr(pslot) == gslot);
	}

	int size();

	bool put(const PayLoad&);
	bool get(PayLoad&);

private:

	PayLoad storage[MaxSize+1];

	int pslot = 0;
	int gslot = 0;

	inline
	static
	int slot_incr(int slot) {
		return (slot+1) % (MaxSize+1);
	}

};

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

#endif
