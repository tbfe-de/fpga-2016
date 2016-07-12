%module fifo
%{
#include "fifo.h"
%}

%include typemaps.i

template<typename PayLoad, int MAXSIZE>
class fifo {
public:
	bool empty();
	bool full();
	int size();
	bool put(const PayLoad &INPUT);
	bool get(PayLoad &OUTPUT);
};

%template (fifo_long_20) fifo<long, 20>;
