all: test

PROGRAM_NAME= multiplefiles
OUT_DIR = ../../../bin/test/$(PROGRAM_NAME)
STARKC = ../../../bin/starkc
LIB_PATH = ../../../bin

compile:
	mkdir -p $(OUT_DIR)
	# Build main with main and functions
	$(STARKC) -d -o ./$(OUT_DIR)/main.bc company.st main.st
	/usr/local/opt/llvm/bin/llc -filetype=obj ./$(OUT_DIR)/main.bc
	# Link code with runtime and create binary
	#gcc -L./$(LIB_PATH) -o ./$(OUT_DIR)/$(PROGRAM_NAME) ./$(OUT_DIR)/main.o -lstark
	# Static link runtime
	gcc -o ./$(OUT_DIR)/$(PROGRAM_NAME) ./$(OUT_DIR)/main.o ./$(LIB_PATH)/libstark.a

test: compile
	./$(OUT_DIR)/$(PROGRAM_NAME) && exit 1 || echo "expected return failure"
