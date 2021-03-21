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

#SANITIZER_FLAGS:=-fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer -g -O1
SANITIZER_FLAGS:=

compile:
	mkdir -p $(OUT_DIR)
	# Build main with main and functions
	$(STARKC) -d -r $(LIB_PATH)/libstark.a -o $(OUT_DIR)/$(PROGRAM_NAME) company.st main.st

test: compile
	$(OUT_DIR)/$(PROGRAM_NAME)
