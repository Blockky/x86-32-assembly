.PHONY: clean

all: files

AS=as
LINK=ld
AFLAGS=-g --32
LFLAGS=-melf_i386

files: files.o
	@$(LINK) $(LFLAGS) -o $@ $^

files.o: fileManagement.s
	@$(AS) $(AFLAGS) -o $@ $<

clean:
	@rm -rf *.o files
	