.PHONY: clean

all: condition

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

condition: condition.o
	@$(LINK) $(LFLAGS) -o $@ $^

condition.o: exitCondition.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o condition
	