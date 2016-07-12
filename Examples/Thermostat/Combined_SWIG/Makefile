# Give help on targets

help:
	@echo "Usage: make <target>"
	@echo "  -or- make <target>.run"
	@echo "  where <target> is one of:"
	@echo "       thermostat-main  -- a bare-bones C-only driver for interactive use"
	@echo "       thermostat-test  -- a TDD inspired main program, displaying just"
	@echo "                            ** TESTS PASSED ** (or which test has failed)"
	@echo "       thermostat.tcl   -- a small GUI based driver written in Tcl/Tk"
	@echo "  adding '.run' will not only update the target but also execute it"
	

all:\
	thermostat.tcl\
	thermostat-main\
	thermostat-test
	@echo "all targets available and up-to-date"

thermostat.tcl:\
	thermostat.so

thermostat-main:\
	thermostat.o\
	thermostat-main.o
	gcc thermostat.o thermostat-main.o -o $@

thermostat-test:\
	thermostat.o\
	thermostat-test.o
	gcc thermostat.o thermostat-test.o -o $@

thermostat.so:\
	thermostat.o\
	thermostat_wrap.o
	gcc -shared thermostat.o thermostat_wrap.o -o$@

thermostat_wrap.o:\
	thermostat_wrap.c
	gcc -c -fPIC -I/usr/include/tcl8.6 thermostat_wrap.c

thermostat_wrap.c:\
	thermostat.i\
	thermostat.h
	swig -tcl thermostat.i

thermostat.o:\
	thermostat.h\
	thermostat.c
	gcc -c -fPIC thermostat.c

thermostat-main.o:\
	thermostat.h\
	thermostat-main.c
	gcc -c thermostat-main.c

thermostat-test.o:\
	thermostat.h\
	thermostat-test.c
	gcc -c thermostat-test.c

thermostat.tcl.run:\
	thermostat.tcl
	@echo "please control Tcl/Tk application via its GUI ..." 
	@wish thermostat.tcl

%.run : %
	@echo "starting executable program ${@:.run=} now ..."
	@./${@:.run=} || echo "execution returned failure"

clean:
	@rm -f a.out core *.o *_wrap.c thermostat.so thermostat-test thermostat-main
