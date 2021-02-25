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

ifeq ($(LLC),)
LLC := /usr/local/opt/llvm/bin/llc
endif

compile:
	# Build main > .bc
	$(STARKC) -d -o $(OUT_DIR)/main.bc main.st
	# Generate object .bc > .o
	# TODO : call llc from compiler !
	${LLC} -filetype=obj $(OUT_DIR)/main.bc
	# Link code with runtime and create binary
	#gcc -L./$(LIB_PATH) -o $(OUT_DIR)/$(PROGRAM_NAME) $(OUT_DIR)/main.o -lstark
	# Static link runtime
	gcc -o $(OUT_DIR)/$(PROGRAM_NAME) $(OUT_DIR)/main.o $(LIB_PATH)/libstark.a

test: compile
	$(OUT_DIR)/$(PROGRAM_NAME) && exit 1 || echo "expected return failure"




#compiler: starkc runtime
	# Build main > .bc > .o
#	./$(OUT_DIR)/starkc -d -o ./$(OUT_DIR)/main.bc test/main.st
#	/usr/local/opt/llvm/bin/llc -filetype=obj ./$(OUT_DIR)/main.bc
	# Build module > .bc > .o
#	./$(OUT_DIR)/starkc -d -o ./$(OUT_DIR)/module.bc test/module.st
#	/usr/local/opt/llvm/bin/llc -filetype=obj ./$(OUT_DIR)/module.bc
	# Build binary (and link stark runtime)
#	$(CC) -L./$(OUT_DIR) -o ./$(OUT_DIR)/main ./$(OUT_DIR)/main.o ./$(OUT_DIR)/module.o -lstark
	# Run output program
#	./$(OUT_DIR)/main