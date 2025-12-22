.PHONY: clean

all: arguments

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

arguments: arguments.o
	@$(LINK) $(LFLAGS) -o $@ $^

arguments.o: stackArguments.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o arguments
	