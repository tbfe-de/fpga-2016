%module fifo
%{
#include "fifo.h"
%}

%include typemaps.i

template<typename PayLoad, int MAXSIZE>
class fifo {
public:
        typedef long payload;
	bool empty();
	bool full();
	int size();
	bool put(const payload &INPUT);
	bool get(payload &OUTPUT);
};

%template (fifo_long_20) fifo<long, 20>;
