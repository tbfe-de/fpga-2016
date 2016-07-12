#ifndef FIFO_H
#define FIFO_H

class fifo {
public:

	using payload = long;

	static constexpr int MAXSIZE = 20;

	inline
	static bool empty() {
		return (gslot == pslot);
	}

	inline
	static bool full() {
		return (slot_incr(pslot) == gslot);
	}

	static int size();

	static bool put(const payload&);
	static bool get(payload&);

private:

	static payload storage[MAXSIZE+1];

	static int pslot;
	static int gslot;

	inline
	static int slot_incr(int slot) {
		return (slot+1) % (MAXSIZE+1);
	}

};

#endif
