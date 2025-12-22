.PHONY: clean

all: addition

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

addition: addition.o
	@$(LINK) $(LFLAGS) -o $@ $^

addition.o: firstSubroutine.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o addition
	