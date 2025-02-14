.POSIX:
.SUFFIXES: .c .o

CC      = gcc
PANDOC  = pandoc

# If the user doesn't specify a PREFIX, default to /usr/local
PREFIX  ?= /usr/local

# Common installation directories
BINDIR  = $(PREFIX)/bin
MANDIR  = $(PREFIX)/share/man
MAN8DIR = $(MANDIR)/man8

BASE_CFLAGS = -std=gnu99 -Wall -Wextra
CFLAGS      = -O2 -g
BASE_LDFLAGS =
LDFLAGS     =

.PHONY: all clean install

all: hpsahba hpsahba.8

.c.o:
	$(CC) $(BASE_CFLAGS) $(CFLAGS) -c -o $@ $<

main.o: hpsa.h

hpsahba: main.o
	$(CC) $(BASE_CFLAGS) $(CFLAGS) $(BASE_LDFLAGS) $(LDFLAGS) -o $@ $^

hpsahba.8: README.md
	$(PANDOC) --from=markdown --to=man --standalone \
		--metadata="title=HPSAHBA(8)" \
		--output=$@ $<

install: hpsahba hpsahba.8
	mkdir -p $(DESTDIR)$(BINDIR)
	install -m 755 hpsahba $(DESTDIR)$(BINDIR)/hpsahba

	mkdir -p $(DESTDIR)$(MAN8DIR)
	install -m 644 hpsahba.8 $(DESTDIR)$(MAN8DIR)/hpsahba.8

clean:
	rm -f *.o
	rm -f hpsahba
	rm -f hpsahba.8
