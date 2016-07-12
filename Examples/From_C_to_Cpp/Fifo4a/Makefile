fifo_demo_app.run: fifo.so
	@./../Fifo0/${@:.run=.tcl}

FIFO_INL=\
	-U INLINE_fifo_empty\
	-U INLINE_fifo_full\
	-U INLINE_fifo_size\
	-D INLINE_fifo_slot_incr

FIFO_SO_OBJS=\
	fifo.o\
	fifo_wrap.o

fifo.so: $(FIFO_SO_OBJS)
	g++ -shared $(FIFO_SO_OBJS) -o $@

fifo.s: fifo.cpp fifo.inl fifo.h
	g++ -std=c++11 -S -O2 -fPIC $(FIFO_INL) fifo.cpp

fifo.o: fifo.s
	g++ -c -fPIC fifo.s

fifo_wrap.o: fifo_wrap.cxx fifo.inl fifo.h
	g++ -std=c++11 -c -O2 -fPIC -I /usr/include/tcl8.6 $(FIFO_INL) fifo_wrap.cxx

fifo_wrap.cxx: fifo.i
	swig -c++ -tcl fifo.i

clean:
	rm -f fifo.so $(FIFO_SO_OBJS) fifo.s fifo_wrap.cxx

fifo.o.size:
	gcc -c -O2 -fPIC $(FIFO_INL) fifo.cpp -o $@
	@size $@
	@rm $@
