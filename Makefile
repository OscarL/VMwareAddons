CC=gcc
CXX=g++
XRES=xres
CFLAGS=-I. -g -W -Wall -Wno-multichar -ansi -pedantic -Werror
LDFLAGS1=-lbe 
LDFLAGS2=-nostart -Xlinker -soname=vmwmouse -Xlinker --no-undefined /system/servers/input_server -lbe

all: menu_app vmwmouse

menu_app: VMWAddOns VMWAddOns.rsrc
	$(XRES) -o $^
	mimeset VMWAddOns

vmwmouse: VMWMouseFilter.o VMWAddOnsSettings.o VMWBackdoor.o
	$(CXX) -o "$@" $^ $(LDFLAGS2)
	mimeset "$@"

VMWAddOns: VMWAddOnsApp.o VMWAddOnsTray.o VMWAddOnsSettings.o VMWBackdoor.o VMWAddOnsCleanup.o VMWAddOnsSelectWindow.o VMWAddOnsStatusWindow.o
	$(CXX) -o "$@" $^ $(LDFLAGS1)

%.o: src/%.cpp
	$(CXX) -o $@ -c $< $(CFLAGS)

%.o: src/%.c
	$(CC) -o $@ -c $< $(CFLAGS)

%.rsrc: src/%.rdef
	cat $< | gcc -E -D__HAIKU__ - | egrep -v '^#' | rc --auto-names -o $@ -

clean:
	rm -rf *.o *.rsrc

mrproper: clean
	rm -rf VMWAddOns vmwmouse

.PHONY: clean mrproper
