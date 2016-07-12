%module fifo
%{
#include "fifo.h"
%}

%include typemaps.i

class fifo {
public:
        typedef long payload;
	bool empty();
	bool full();
	int size();
	bool put(const payload &INPUT);
	bool get(payload &OUTPUT);
};
