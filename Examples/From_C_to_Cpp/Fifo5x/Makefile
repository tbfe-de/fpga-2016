fifo_demo_app.run: fifo.so
	@./../Fifo0/${@:.run=.tcl}

FIFO_SO_OBJS=\
	fifo.o\
	fifo_wrap.o

fifo.so: $(FIFO_SO_OBJS)
	g++ -shared $(FIFO_SO_OBJS) -o $@

fifo.s: fifo.c fifo.h
	gcc -std=c99 -S -O2 -fPIC fifo.c

fifo.o: fifo.s
	gcc -c fifo.s
	@size $@

fifo_wrap.o: fifo_wrap.c fifo.h
	gcc -std=c99 -c -O2 -fPIC -I /usr/include/tcl8.6 fifo_wrap.c

fifo_wrap.c: fifo.i
	swig -tcl fifo.i

clean:
	rm -f fifo.so $(FIFO_SO_OBJS) fifo.s fifo_wrap.c

fifo.o.size:
	gcc -std=c99 -c -O2 -fPIC fifo.c -o $@
	@size $@
	@rm $@

fifo.o.objdump:
	gcc -std=c99 -c -O2 -fPIC fifo.c -o $@
	@objdump -d $@
	@rm $@
