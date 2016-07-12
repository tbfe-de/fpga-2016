#ifndef FIFO_H
#define FIFO_H

template<typename PayLoad, int MaxSize>
class fifo {
public:

	using payload = PayLoad;

	static constexpr int MAXSIZE = MaxSize;

	fifo() {}

	inline
	bool empty() const {
		return (gslot == pslot);
	}

	inline
	bool full() const {
		return (slot_incr(pslot) == gslot);
	}

	int size() const;

	bool put(const payload&);
	bool get(payload&);

private:

	payload storage[MAXSIZE+1];

	int pslot = 0;
	int gslot = 0;

	inline
	static
	int slot_incr(int slot) {
		return (slot+1) % (MAXSIZE+1);
	}

};

template<typename PayLoad, int MaxSize>
int fifo<PayLoad, MaxSize>::size() const {
	return (pslot >= gslot)
		? pslot - gslot
		: pslot + (MAXSIZE+1) - gslot;
}

template<typename PayLoad, int MaxSize>
bool fifo<PayLoad, MaxSize>::put(const payload& pl) {
	if (full()) return false;
	storage[pslot] = pl;
	pslot = slot_incr(pslot);
	return true;
}

template<typename PayLoad, int MaxSize>
bool fifo<PayLoad, MaxSize>::get(payload &pl) {
	if (empty()) return false;
	pl = storage[gslot];
	gslot = slot_incr(gslot);
	return true;
}

#endif
