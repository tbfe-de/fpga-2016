#ifndef FIFO_H
#define FIFO_H

class fifo {
public:

	using payload = long;

	static constexpr int MAXSIZE = 20;

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
	static int slot_incr(int slot) {
		return (slot+1) % (MAXSIZE+1);
	}

};

#endif
