include config.mk

CC := gcc
CFLAGS := -Wall -Wextra -Wno-unused-function -Wno-unused-parameter
CFLAGS += -std=gnu99
CFLAGS += -L$(RAYLIB_INSTALL)/lib 
CFLAGS += -I$(RAYLIB_INSTALL)/include
CFLAGS += -I./includes
cfiles := $(wildcard ./src/*.c)
objs := $(patsubst ./src/%.c, ./bin/%.o, $(cfiles))
.PHONY: all release clean debug debug_target run

all: debug_target
release: CFLAGS += -O2
release: clean $(target)

debug: clean debug_target
debug_target: CFLAGS += -Wconversion -Werror -Wno-error=conversion -g -O0 -D DEBUG
debug_target: $(target)

$(target): $(objs)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

./bin/%.o: ./src/%.c
	$(CC) $(CFLAGS) -o $@ -c $<

clean: 
	-@rm -f $(target) $(objs)

run: debug_target
	@$(target)

# Target for devs only, compiles for a windows target and runs on a linux host. Requires
# some kind windows runtime (the default is wine), a linux-host, a windows-target cross
# compiler (default is mingw-w64), and a windows-target compiled raylib.
winrun:
	$(MAKE) -C wintest -f winrun.mk run

winclean:
	$(MAKE) -C wintest -f winrun.mk clean
