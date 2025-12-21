.PHONY: clean

all: condition2

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

condition2: condition2.o
	@$(LINK) $(LFLAGS) -o $@ $^

condition2.o: lowerCaseCondition.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o condition2
	