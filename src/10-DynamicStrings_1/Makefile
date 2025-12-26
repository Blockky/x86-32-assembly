.PHONY: clean

all: cstrings

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

cstrings: main.o library.o
	@$(LINK) $(LFLAGS) -o $@ $^

library.o: library.s
	@$(AS) $(AFLAGS) -o $@ $<
	
main.o: main.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o cstrings
	