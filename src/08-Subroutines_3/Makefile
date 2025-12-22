.PHONY: clean

all: strtoul2

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

strtoul2: strtoul2.o
	@$(LINK) $(LFLAGS) -o $@ $^

strtoul2.o: strtoul2.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o strtoul2
	