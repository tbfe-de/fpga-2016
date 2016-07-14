fifo_demo_app.run: fifo.so
	@./../Fifo0/${@:.run=.tcl}

FIFO_SO_OBJS=\
	fifo.o\
	fifo_wrap.o

fifo.so: $(FIFO_SO_OBJS)
	g++ -shared $(FIFO_SO_OBJS) -o $@

fifo.s: fifo.cpp fifo.h
	g++ -std=c++11 -S -O2 -fPIC fifo.cpp

fifo.o: fifo.s
	g++ -c fifo.s

fifo_wrap.o: fifo_wrap.cxx fifo.h
	g++ -std=c++11 -c -O2 -fPIC -I /usr/include/tcl8.6 fifo_wrap.cxx

fifo_wrap.cxx: fifo.i
	swig -c++ -tcl fifo.i

clean:
	rm -f fifo.so $(FIFO_SO_OBJS) fifo.s fifo_wrap.cxx

fifo.o.size:
	g++ -std=c++11 -c -O2 fifo.cpp -o $@
	@size $@
	@rm $@

fifo.o.objdump:
	g++ -std=c++11 -c -O2 -fPIC -fno-exceptions fifo.cpp -o $@
	objdump -dC $@
	@rm $@
