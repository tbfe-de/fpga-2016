%module fifo
%{
#include "fifo.h"
%}

%import "typemaps.i"

typedef long fifo_payload;

int fifo_empty();
int fifo_full();
int fifo_size();

int fifo_put(const fifo_payload *INPUT);

int fifo_get(fifo_payload *OUTPUT);
