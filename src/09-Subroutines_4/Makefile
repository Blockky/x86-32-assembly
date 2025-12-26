.PHONY: clean

all: ultostr

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

ultostr: ultostr.o
	@$(LINK) $(LFLAGS) -o $@ $^

ultostr.o: ultostr.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o ultostr
	