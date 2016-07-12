#ifndef FIFO_H
#define FIFO_H

typedef long fifo_payload;

#define FIFO_MAXSIZE 20

int fifo_empty();
int fifo_full();
int fifo_size();

int fifo_put(const fifo_payload *);
int fifo_get(fifo_payload *);

#endif
