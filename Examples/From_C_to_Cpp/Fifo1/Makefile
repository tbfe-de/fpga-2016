fifo_demo_app.run: fifo.so
	@./../Fifo0/${@:.run=.tcl}

FIFO_SO_OBJS=\
	fifo.o\
	fifo_wrap.o

fifo.so: $(FIFO_SO_OBJS)
	gcc -shared $(FIFO_SO_OBJS) -o $@

fifo.s: fifo.c fifo.h
	gcc -S -O2 -fPIC fifo.c

fifo.o: fifo.s
	gcc -c -fPIC fifo.s

fifo_wrap.o: fifo_wrap.c fifo.h
	gcc -c -O2 -fPIC -I /usr/include/tcl8.6 fifo_wrap.c

fifo_wrap.c: fifo.i
	swig -tcl fifo.i

clean:
	rm -f fifo.so $(FIFO_SO_OBJS) fifo.s fifo_wrap.c

fifo.o.size:
	gcc -c -O2 -fPIC -D MACRO_FOR_SLOT_INCR=0 fifo.c -o $@
	@size $@
	@rm $@

