# 1 "fifo.cpp"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "fifo.cpp"
# 1 "fifo.h" 1
# 40 "fifo.h"
class fifo {
public:

 using payload = long;

 static constexpr int MAXSIZE = 20;


 static bool empty();


 static bool full();


 static int size();

 static bool put(const payload&);
 static bool get(payload&);

private:

 static payload storage[MAXSIZE+1];

 static int pslot;
 static int gslot;


 static int slot_incr(int slot);

};


# 1 "fifo.inl" 1
# 73 "fifo.h" 2
# 2 "fifo.cpp" 2


# 1 "fifo.inl" 1

bool fifo::empty() {
 return (gslot == pslot);
}



bool fifo::full() {
 return (slot_incr(pslot) == gslot);
}



int fifo::size() {
 return (pslot >= gslot)
  ? pslot - gslot
  : pslot + (MAXSIZE+1) - gslot;
}



int fifo::slot_incr(int slot) {
 return (slot+1) % (MAXSIZE+1);
}
# 5 "fifo.cpp" 2


bool fifo::put(const payload& pl) {
 if (full()) return false;
 storage[pslot] = pl;
 pslot = slot_incr(pslot);
 return true;
}

bool fifo::get(payload &pl) {
 if (empty()) return false;
 pl = storage[gslot];
 gslot = slot_incr(gslot);
 return true;
}

fifo::payload fifo::storage[fifo::MAXSIZE+1];

int fifo::pslot = 0;
int fifo::gslot = 0;
