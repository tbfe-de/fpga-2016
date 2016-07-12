#if (JSRCALL_fifo_empty != FIFO_INL_INCLUDED_FROM_H)
bool fifo::empty() {
	return (gslot == pslot);
}
#endif

#if (JSRCALL_fifo_full != FIFO_INL_INCLUDED_FROM_H)
bool fifo::full() {
	return (slot_incr(pslot) == gslot);
}
#endif

#if (JSRCALL_fifo_size != FIFO_INL_INCLUDED_FROM_H)
int fifo::size() {
	return (pslot >= gslot)
		? pslot - gslot
		: pslot + (MAXSIZE+1) - gslot;
}
#endif

#if (JSRCALL_fifo_slot_incr != FIFO_INL_INCLUDED_FROM_H)
int fifo::slot_incr(int slot) {
	return (slot+1) % (MAXSIZE+1);
}
#endif
