# fadwm - fork against dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c fadwm.c util.c
OBJ = ${SRC:.c=.o}

all: options fadwm

options:
	@echo fadwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

fadwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f fadwm ${OBJ} fadwm-${VERSION}.tar.gz

dist: clean
	mkdir -p fadwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		fadwm.1 drw.h util.h ${SRC} fadwm.png transient.c fadwm-${VERSION}
	tar -cf fadwm-${VERSION}.tar fadwm-${VERSION}
	gzip fadwm-${VERSION}.tar
	rm -rf fadwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f fadwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/fadwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < fadwm.1 > ${DESTDIR}${MANPREFIX}/man1/fadwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/fadwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/fadwm\
		${DESTDIR}${MANPREFIX}/man1/fadwm.1

.PHONY: all options clean dist install uninstall
