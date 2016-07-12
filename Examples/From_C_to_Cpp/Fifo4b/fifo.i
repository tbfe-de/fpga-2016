%module fifo
%{
#include "fifo.cpp"
%}

%include typemaps.i

template<typename PayLoad, int MaxSize>
class fifo {
public:
	static bool empty();
	static bool full();
	static int size();
	static bool put(const PayLoad &INPUT);
	static bool get(PayLoad &OUTPUT);
};

%template (fifo_long_20) fifo<long, 20>;
