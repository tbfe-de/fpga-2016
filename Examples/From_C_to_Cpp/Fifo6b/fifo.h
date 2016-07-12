#ifndef FIFO_H
#define FIFO_H

#include <cstddef>

template<typename PayLoad, std::size_t MaxSize>
class fifo {
public:
	using value_type = PayLoad;
	using size_type = std::size_t;

	inline
	static constexpr size_type max_size() {
		return MaxSize;
	}

	fifo() 				=default;
	fifo(const fifo &)		=default;
	fifo(fifo &&)			=default;
	fifo& operator=(const fifo &)	=default;
	fifo& operator=(fifo &&)	=default;

	inline
	auto empty() const {
		return (gslot == pslot);
	}

	inline
	auto full() const {
		return (slot_incr(pslot) == gslot);
	}

	auto size() const -> size_type;

	auto put(const PayLoad&) -> bool;
	auto get(PayLoad&) -> bool;

private:

	PayLoad storage[MaxSize+1];

	size_type pslot = 0;
	size_type gslot = 0;

	inline
	static auto slot_incr(int slot) {
		return (slot+1) % (MaxSize+1);
	}

};

template<typename PayLoad, std::size_t MaxSize>
auto fifo<PayLoad, MaxSize>::size() const -> size_type {
	return (pslot >= gslot)
		? pslot - gslot
		: pslot + (MaxSize+1) - gslot;
}

template<typename PayLoad, std::size_t MaxSize>
auto fifo<PayLoad, MaxSize>::put(const PayLoad& pl) -> bool {
	if (full()) return false;
	storage[pslot] = pl;
	pslot = slot_incr(pslot);
	return true;
}

template<typename PayLoad, std::size_t MaxSize>
auto fifo<PayLoad, MaxSize>::get(PayLoad &pl) -> bool {
	if (empty()) return false;
	pl = storage[gslot];
	gslot = slot_incr(gslot);
	return true;
}

#endif
