.PHONY: clean

all: case

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

case: case.o
	@$(LINK) $(LFLAGS) -o $@ $^

case.o: caseFlipper.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o case
	