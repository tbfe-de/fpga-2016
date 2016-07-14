#include <cassert>
#include <iostream>
#include "fifo.h"

int main() {
	fifo<long, 20> test_fifo;

	assert(test_fifo.empty()); assert(test_fifo.size() == 0);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 1);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 2);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 3);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 4);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 5);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 6);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 7);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 8);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 9);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 10);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 11);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 12);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 13);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 14);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 15);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 16);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 17);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 18);
	test_fifo.put(0L);
	assert(!test_fifo.empty()); assert(test_fifo.size() == 19);
	test_fifo.put(0L);
	assert(test_fifo.full());

	long dummy;
	test_fifo.get(dummy);
	assert(!test_fifo.full());

	std::cout << "ALL TESTS PASSED" << std::endl;
}
