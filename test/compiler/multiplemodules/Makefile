all: test

.EXPORT_ALL_VARIABLES:

PROGRAM_NAME= multiplemodules
OUT_DIR = ../../../bin/test/$(PROGRAM_NAME)
STARKC = ../../../bin/starkc
LIB_PATH = ../../../bin
STARK_MODULE_PATH=$(OUT_DIR)/modules

modules:
	rm -rf $(OUT_DIR)/modules
	mkdir -p $(OUT_DIR)/modules
	$(STARKC) -d -o ./$(OUT_DIR)/modules company/functions.st company/types.st

main: modules
	$(STARKC) -d -o ./$(OUT_DIR)/main.bc main.st
	/usr/local/opt/llvm/bin/llc -filetype=obj ./$(OUT_DIR)/main.bc
	# Link code with runtime and create binary
	#gcc -L./$(LIB_PATH) -o ./$(OUT_DIR)/$(PROGRAM_NAME) ./$(OUT_DIR)/main.o -lstark
	# Static link runtime
	gcc -o ./$(OUT_DIR)/$(PROGRAM_NAME) ./$(OUT_DIR)/main.o ./$(LIB_PATH)/libstark.a

test: main
	./$(OUT_DIR)/$(PROGRAM_NAME) && exit 1 || echo "expected return failure"
