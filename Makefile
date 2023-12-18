CC          := gcc
WARNINGS    := -Wall
PY_INCLUDE  := $(shell python -c "import sysconfig; print(sysconfig.get_path('include'))")
PY_VERSION  := $(shell python -c "import sysconfig; print(sysconfig.get_python_version())")
INTERPRETER := $(shell readelf -l /bin/sh | grep "Requesting program interpreter" | grep -Eo '/[^]]*')
C_RUNTIME   := $(shell echo /usr/lib/crt{1,i,n}.o)
BUILDDIR    := $(PWD)
LIBS        := -lc2 -lrust -lasm -lcython -lc
SRC         := src
O           := obj
L           := lib
E           := babel

ifeq ($(shell id -u),0)
    PREFIX ?= /usr/local
else
    PREFIX ?= $(HOME)/.local
endif

default: init c rust asm cython main link

init:
	@echo gen.sys --offset 11:1
	@mkdir -p $(O) $(L) $(C)

c:
	gcc $(WARNINGS) -shared -fPIC -o $(L)/libc2.so $(SRC)/c.c

rust:
	rustc --crate-type=cdylib -o $(L)/librust.so $(SRC)/rust.rs

asm:
	nasm -f elf64 $(SRC)/asm.asm -o $(O)/asm.o
	gcc $(WARNINGS) -shared -fPIC -o $(L)/libasm.so $(O)/asm.o

cython:
	cythonize -3 $(SRC)/cython3.pyx
	mv -v $(SRC)/cython3.{c,h} $(O)/
	gcc $(WARNINGS) -shared -I$(O) -I$(PY_INCLUDE) -fPIC -o $(L)/libcython.so $(O)/cython3.c -lpython$(PY_VERSION)

main:
	gcc $(WARNINGS) -c -o $(O)/main.o $(SRC)/main.c

link:
	ld -o $(E) -L$(PWD)/$(L) -rpath $(PWD)/$(L) -dynamic-linker $(INTERPRETER) $(LIBS) $(C_RUNTIME) $(O)/main.o
	@printf "You can now run %s\n" ./$(E)

install:
	@echo PREFIX is $(PREFIX)
	install -d   $(PREFIX)/bin
	install $(E) $(PREFIX)/bin

clean:
	rm -rf $(O) $(E)

check:
	pytest -v tests
