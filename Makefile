
ALL_TARGET=a.so b.so c.so
CLEAN_TARGET= $(ALL_TARGET) a.o b.o c.o 

all: $(ALL_TARGET)

clean:
	for i in $(CLEAN_TARGET) *~ ; do if [ -e $$i ] ; then rm $$i ; fi ; done;

.PHONY: all clean

a.so: a.o
	gcc --shared -o $@ $<
b.so: b.o
	gcc --shared -o $@ $<
c.so: c.o
	gcc --shared -o $@ $<
a.o: a.c a.h
b.o: b.c a.h b.h 
c.o: c.c a.h b.h

