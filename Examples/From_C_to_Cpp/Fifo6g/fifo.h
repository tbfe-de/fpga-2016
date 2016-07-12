#ifndef FIFO_H
#define FIFO_H

#include <array>
#include <cstddef>
#include <memory>
#include <type_traits>

template<typename PayLoad>
class fifo_storage {
public:

	using size_type = std::size_t;
	using value_type = PayLoad;

protected:

	fifo_storage(std::size_t size)
		: storage(new PayLoad[size])
		, wrap_size(size)
	{}

	fifo_storage(const fifo_storage &)		=delete;
	fifo_storage& operator=(const fifo_storage &)	=delete;

	fifo_storage(fifo_storage &&)			=default;
	fifo_storage& operator=(fifo_storage &&)	=default;

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
	std::unique_ptr<PayLoad[]> storage;
	const std::size_t wrap_size;

	inline
	auto slot_incr(int slot) const {
		return (slot+1) % wrap_size;
	}

	size_type pslot = 0;
	size_type gslot = 0;
};

template<typename PayLoad>
auto fifo_storage<PayLoad>::size() const -> std::size_t {
	return (pslot >= gslot)
		? pslot - gslot
		: pslot + wrap_size - gslot;
}

template<typename PayLoad>
auto fifo_storage<PayLoad>::put(in_arg_type pl) -> bool {
	if (full()) return false;
	storage[pslot] = pl;
	pslot = slot_incr(pslot);
	return true;
}

template<typename PayLoad>
auto fifo_storage<PayLoad>::get(out_arg_type pl) -> bool {
	if (empty()) return false;
	pl = storage[gslot];
	gslot = slot_incr(gslot);
	return true;
}

template<typename PayLoad, typename fifo_storage<PayLoad>::size_type MaxSize>
class fifo : private fifo_storage<PayLoad> {
public:
	using value_type = typename fifo_storage<PayLoad>::value_type;
	using size_type = typename fifo_storage<PayLoad>::size_type;

	using fifo_storage<PayLoad>::empty;
	using fifo_storage<PayLoad>::full;
	using fifo_storage<PayLoad>::size;
	using fifo_storage<PayLoad>::put;
	using fifo_storage<PayLoad>::get;

	inline
	static constexpr size_type max_size() {
		return MaxSize;
	}

	fifo();

};

template<typename PayLoad, typename fifo_storage<PayLoad>::size_type MaxSize>
inline
fifo<PayLoad, MaxSize>::fifo()
	: fifo_storage<PayLoad>(MaxSize)
{}

#endif
