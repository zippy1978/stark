all: test

ifeq ($(PROGRAM_NAME),)
PROGRAM_NAME := multiplefiles
endif

ifeq ($(OUT_DIR),)
OUT_DIR := ../../../bin/test/$(PROGRAM_NAME)
endif

ifeq ($(STARKC),)
STARKC := ../../../bin/starkc
endif

ifeq ($(LIB_PATH),)
LIB_PATH := ../../../bin
endif

ifeq ($(LLC),)
LLC := /usr/local/opt/llvm/bin/llc
endif

compile:
	mkdir -p $(OUT_DIR)
	# Build main with main and functions
	$(STARKC) -d -o $(OUT_DIR)/main.bc company.st main.st
	$(LLC) -filetype=obj $(OUT_DIR)/main.bc
	# Link code with runtime and create binary
	#gcc -L$(LIB_PATH) -o $(OUT_DIR)/$(PROGRAM_NAME) $(OUT_DIR)/main.o -lstark
	# Static link runtime
	gcc -pthread -o $(OUT_DIR)/$(PROGRAM_NAME) $(OUT_DIR)/main.o $(LIB_PATH)/libstark.a

test: compile
	$(OUT_DIR)/$(PROGRAM_NAME)
