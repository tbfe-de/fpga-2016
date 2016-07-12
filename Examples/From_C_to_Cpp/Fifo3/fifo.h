#ifndef FIFO_H
#define FIFO_H

class fifo {
public:

	using payload = long;

	static constexpr int MAXSIZE = 20;

	static bool empty();
	static bool full();
	static int size();

	static bool put(const payload&);
	static bool get(payload&);

private:

	static payload storage[MAXSIZE+1];

	static int pslot;
	static int gslot;

	static int slot_incr(int slot);

};

#endif
