#ifndef FIFO_H
#define FIFO_H

#include <cstddef>

template<typename T> struct fifo_payload_arg 		{ using type = const T&; };
template<> struct fifo_payload_arg<char> 		{ using type = char; };
template<> struct fifo_payload_arg<signed char> 	{ using type = signed char; };
template<> struct fifo_payload_arg<signed short> 	{ using type = signed short; };
template<> struct fifo_payload_arg<signed int> 		{ using type = signed int; };
template<> struct fifo_payload_arg<signed long>		{ using type = signed long; };
template<> struct fifo_payload_arg<signed long long>	{ using type = signed long long; };
template<> struct fifo_payload_arg<unsigned char>	{ using type = unsigned char; };
template<> struct fifo_payload_arg<unsigned short>	{ using type = unsigned short; };
template<> struct fifo_payload_arg<unsigned int>	{ using type = unsigned int; };
template<> struct fifo_payload_arg<unsigned long>	{ using type = unsigned long; };
template<> struct fifo_payload_arg<unsigned long long>	{ using type = unsigned long long; };

template<typename T> using fifo_payload_arg_t = typename fifo_payload_arg<T>::type;


template<typename PayLoad>
class fifo_access {
public:

	using size_type = std::size_t;
	using value_type = PayLoad;

protected:

	fifo_access(PayLoad data[], std::size_t size)
		: storage(data), wrap_size(size)
	{}

	auto put(fifo_payload_arg_t<PayLoad>) -> bool;
	auto get(PayLoad&) -> bool;

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
auto fifo_access<PayLoad>::put(fifo_payload_arg_t<PayLoad> pl) -> bool {
	if (full()) return false;
	storage[pslot] = pl;
	pslot = slot_incr(pslot);
	return true;
}

template<typename PayLoad>
auto fifo_access<PayLoad>::get(PayLoad &pl) -> bool {
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
