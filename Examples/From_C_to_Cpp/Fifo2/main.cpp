#include <cassert>
#include <iostream>
#include "fifo.h"

int main() {
	assert(fifo::empty()); assert(fifo::size() == 0);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 1);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 2);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 3);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 4);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 5);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 6);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 7);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 8);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 9);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 10);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 11);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 12);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 13);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 14);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 15);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 16);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 17);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 18);
	fifo::put(0L);
	assert(!fifo::empty()); assert(fifo::size() == 19);
	fifo::put(0L);
	assert(fifo::full());

	{
		using namespace fifo;
		long dummy;
		get(dummy);
		assert(!full());
	}

	std::cout << "ALL TESTS PASSED" << std::endl;
}
