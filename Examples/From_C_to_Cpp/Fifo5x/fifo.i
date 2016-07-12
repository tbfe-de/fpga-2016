%module fifo
%{
#include "fifo.h"
%}

%include typemaps.i

typedef long fifo_payload;

enum {fifo_MAXSIZE = 20};
typedef struct {
	int pslot;
	int gslot;
	fifo_payload storage[fifo_MAXSIZE];
} fifo;;

void fifo_init(fifo*);
bool fifo_empty(const fifo*);
bool fifo_full(const fifo*);
int fifo_size(const fifo*);
bool fifo_put(fifo*, const fifo_payload *INPUT);
bool fifo_get(fifo*, fifo_payload *OUTPUT);
