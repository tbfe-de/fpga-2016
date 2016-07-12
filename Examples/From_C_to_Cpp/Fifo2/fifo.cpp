#include "fifo.h"

namespace {

	using namespace fifo;

	payload storage[MAXSIZE+1];

	int pslot = 0;
	int gslot = 0;

	inline
	int slot_incr(int slot) {
		return (slot+1) % (MAXSIZE+1);
	}
}

namespace fifo{

	bool empty() {
		return (gslot == pslot);
	}

	bool full() {
		return (slot_incr(pslot) == gslot);
	}

	int size() {
		return (pslot >= gslot)
			? pslot - gslot
			: pslot + (MAXSIZE+1) - gslot;
	}

	bool put(const payload& pl) {
		if (full()) return false;
		storage[pslot] = pl;
		pslot = slot_incr(pslot);
		return true;
	}

	bool get(payload &pl) {
		if (empty()) return false;
		pl = storage[gslot];
		gslot = slot_incr(gslot);
		return true;
	}

}
