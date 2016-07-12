%module fifo
%{
#include "fifo.h"
%}

%include typemaps.i

%rename (fifo_empty) fifo::empty;
%rename (fifo_full) fifo::full;
%rename (fifo_size) fifo::size;
%rename (fifo_put) fifo::put;
%rename (fifo_get) fifo::get;

namespace fifo {
	bool empty();
	bool full();
	int size();
	bool put(const long &INPUT);
	bool get(long &OUTPUT);
}
