.PHONY: clean

all: hello

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

hello: hello.o
	@$(LINK) $(LFLAGS) -o $@ $^

hello.o: helloWorld.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o hello
	