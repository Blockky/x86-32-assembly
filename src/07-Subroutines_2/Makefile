.PHONY: clean

all: strtoul

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

strtoul: strtoul.o
	@$(LINK) $(LFLAGS) -o $@ $^

strtoul.o: strtoul.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o strtoul
	