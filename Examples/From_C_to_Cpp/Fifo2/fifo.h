#ifndef FIFO_H
#define FIFO_H


namespace fifo {

	using payload = long;

	constexpr int MAXSIZE = 20;

	bool empty();
	bool full();
	int size();

	bool put(const payload&);
	bool get(payload&);

}

#endif
