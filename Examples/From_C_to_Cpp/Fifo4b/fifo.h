#ifndef FIFO_H
#define FIFO_H

template<typename PayLoad, int MaxSize>
class fifo {
public:

	using payload = PayLoad;

	static constexpr int MAXSIZE = MaxSize;
	
	static bool empty() {
		return (gslot == pslot);
	}

	static bool full() {
		return (slot_incr(pslot) == gslot);
	}

	static int size();

	static bool put(const payload&);
	static bool get(payload&);

private:

	static PayLoad storage[MaxSize+1];

	static int pslot;
	static int gslot;

	static int slot_incr(int slot) {
		return (slot+1) % (MAXSIZE+1);
	}

};

#endif
