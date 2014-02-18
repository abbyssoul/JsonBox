# JsonBox Makefile
# Author: Samuel Dionne-Riel <samuel@dionne-riel.com>

# Project name. The library name is derived from this
PROJECT = JsonBox

CFLAGS += -I./include/
CXXFLAGS = $(CFLAGS)

ifeq (1,${DEBUG})
	CFLAGS += -g
endif

ifeq (1,${USE_CLANG})
	AR = ar
	CXX=clang++
	CXXFLAGS += -std=c++11 -stdlib=libc++
	LINK = clang++
	LFLAGS = -ccc-gcc-name g++ -stdlib=libc++
  	LIBS= $(SUBLIBS) -lJsonBox -lc++abi
endif

SRC = $(wildcard src/*.cpp)
OBJS = $(SRC:src/%.cpp=build/objs/%.o)

LIBNAME = lib$(PROJECT).a

lib:build/objs build/$(LIBNAME)

all: lib examples

build/$(LIBNAME): $(OBJS)
	$(AR) cr $@ $(OBJS)

build/objs:
	mkdir -p $@

build/objs/%.o: src/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Example programs

examples: build/example1

build/example1: examples/main.cpp build/objs build/$(LIBNAME)
	$(CXX) $(CXXFLAGS) -o $@ $< -Lbuild -l$(PROJECT) 
	chmod +x $@

# Phony targets

clean:
	$(RM) -r build

rebuild: clean all

help:
	@echo "JsonBox Makefile"
	@echo "----------------"
	@echo "To compile everything, simply make."
	@echo "Available parameters:"
	@echo "    lib        Builds the library"
	@echo "    examples	  Builds examples" 
	@echo "    DEBUG=1    Builds with debug symbols"

.PHONY: clean rebuild help \
	lib \
	examples
