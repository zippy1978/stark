all: test

ifeq ($(PROGRAM_NAME),)
PROGRAM_NAME := singlefile
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
	# Build main > .bc
	$(STARKC) -d -o $(OUT_DIR)/main.o main.st
	# Link code with runtime and create binary
	#gcc -L./$(LIB_PATH) -o $(OUT_DIR)/$(PROGRAM_NAME) $(OUT_DIR)/main.o -lstark
	# Static link runtime
	gcc -pthread $(SANITIZER_FLAGS) -o $(OUT_DIR)/$(PROGRAM_NAME) $(OUT_DIR)/main.o $(LIB_PATH)/libstark.a

test: compile
	$(OUT_DIR)/$(PROGRAM_NAME)
