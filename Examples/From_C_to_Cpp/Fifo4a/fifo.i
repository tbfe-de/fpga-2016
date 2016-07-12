%module fifo
%{
#include "fifo.h"
%}

%include typemaps.i

class fifo {
public:
        typedef long payload;
	static bool empty();
	static bool full();
	static int size();
	static bool put(const payload &INPUT);
	static bool get(payload &OUTPUT);
};
