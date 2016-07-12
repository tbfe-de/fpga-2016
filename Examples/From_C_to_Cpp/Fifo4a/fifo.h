#ifndef FIFO_H
#define FIFO_H

#ifdef INLINE_fifo_empty
#undef INLINE_fifo_empty
#define INLINE_fifo_empty inline
#define JSRCALL_fifo_empty 0
#else
#define INLINE_fifo_empty
#define JSRCALL_fifo_empty 1
#endif

#ifdef INLINE_fifo_full
#undef INLINE_fifo_full
#define INLINE_fifo_full inline
#define JSRCALL_fifo_full 0
#else
#define INLINE_fifo_full
#define JSRCALL_fifo_full 1
#endif

#ifdef INLINE_fifo_size
#undef INLINE_fifo_size
#define INLINE_fifo_size inline
#define JSRCALL_fifo_size 0
#else
#define INLINE_fifo_size
#define JSRCALL_fifo_size 1
#endif

#ifdef INLINE_fifo_slot_incr
#undef INLINE_fifo_slot_incr
#define INLINE_fifo_slot_incr inline
#define JSRCALL_fifo_slot_incr 0
#else
#define INLINE_fifo_slot_incr
#define JSRCALL_fifo_slot_incr 1
#endif

class fifo {
public:

	using payload = long;

	static constexpr int MAXSIZE = 20;

	INLINE_fifo_empty
	static bool empty();

	INLINE_fifo_full
	static bool full();

	INLINE_fifo_size
	static int size();

	static bool put(const payload&);
	static bool get(payload&);

private:

	static payload storage[MAXSIZE+1];

	static int pslot;
	static int gslot;

	INLINE_fifo_slot_incr
	static int slot_incr(int slot);

};

#define FIFO_INL_INCLUDED_FROM_H 1
#include "fifo.inl"
#undef FIFO_INL_INCLUDED_FROM_H

#endif
