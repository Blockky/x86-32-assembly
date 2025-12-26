.PHONY: clean

all: cstrings2

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

cstrings2: main2.o library2.o
	@$(LINK) $(LFLAGS) -o $@ $^

library2.o: library2.s
	@$(AS) $(AFLAGS) -o $@ $<
	
main2.o: main2.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o cstrings2
	