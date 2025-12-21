.PHONY: clean

all: write

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

write: write.o
	@$(LINK) $(LFLAGS) -o $@ $^

write.o: writeStrings.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o write
	