#ifndef FIFO_H
#define FIFO_H

#include <cstddef>
#include <type_traits>

template<typename T>
template<typename PayLoad>
class fifo_access {
public:

	using size_type = std::size_t;
	using value_type = PayLoad;

protected:

	fifo_access(PayLoad data[], std::size_t size)
		: storage(data), wrap_size(size)
	{}

	using in_arg_type = std::conditional_t<
				(sizeof(PayLoad) <= 4),
				PayLoad,
				const PayLoad&>;
	using out_arg_type = PayLoad&;

	auto put(in_arg_type) -> bool;
	auto get(out_arg_type) -> bool;

	inline
	auto empty() const {
		return (gslot == pslot);
	}

	inline
	auto full() const {
		return (slot_incr(pslot) == gslot);
	}

	auto size() const -> size_type;

private:
	PayLoad *const storage;
	const std::size_t wrap_size;

	inline
	auto slot_incr(int slot) const {
		return (slot+1) % wrap_size;
	}

	size_type pslot = 0;
	size_type gslot = 0;
};

template<typename PayLoad>
auto fifo_access<PayLoad>::size() const -> std::size_t {
	return (pslot >= gslot)
		? pslot - gslot
		: pslot + wrap_size - gslot;
}

template<typename PayLoad>
auto fifo_access<PayLoad>::put(in_arg_type pl) -> bool {
	if (full()) return false;
	storage[pslot] = pl;
	pslot = slot_incr(pslot);
	return true;
}

template<typename PayLoad>
auto fifo_access<PayLoad>::get(out_arg_type pl) -> bool {
	if (empty()) return false;
	pl = storage[gslot];
	gslot = slot_incr(gslot);
	return true;
}

template<typename PayLoad, typename fifo_access<PayLoad>::size_type MaxSize>
class fifo : private fifo_access<PayLoad> {
public:
	using value_type = typename fifo_access<PayLoad>::value_type;
	using size_type = typename fifo_access<PayLoad>::size_type;

	using fifo_access<PayLoad>::empty;
	using fifo_access<PayLoad>::full;
	using fifo_access<PayLoad>::size;
	using fifo_access<PayLoad>::put;
	using fifo_access<PayLoad>::get;

	inline
	static constexpr size_type max_size() {
		return MaxSize;
	}

	fifo();

	fifo(const fifo &)		=delete;
	fifo(fifo &&)			=delete;
	fifo& operator=(const fifo &)	=delete;
	fifo& operator=(fifo &&)	=delete;

private:

	PayLoad storage[MaxSize+1];

};

template<typename PayLoad, typename fifo_access<PayLoad>::size_type MaxSize>
inline
fifo<PayLoad, MaxSize>::fifo()
	: fifo_access<PayLoad>(&storage[0], MaxSize+1)
{}

#endif
