all: test

.EXPORT_ALL_VARIABLES:

ifeq ($(STARK_MODULE_PATH),)
STARK_MODULE_PATH=$(OUT_DIR)/modules
endif

ifeq ($(PROGRAM_NAME),)
PROGRAM_NAME := multiplemodules
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

clean:
	rm -rf $(OUT_DIR)/modules

product_module: clean
	mkdir -p $(OUT_DIR)/modules
	$(STARKC) -d -o $(OUT_DIR)/modules product/functions.st product/types.st


company_module: product_module
	mkdir -p $(OUT_DIR)/modules
	$(STARKC) -d -o $(OUT_DIR)/modules company/functions.st company/types.st

main: company_module
	$(STARKC) -d -o $(OUT_DIR)/main.bc main.st
	$(LLC) -filetype=obj $(OUT_DIR)/main.bc
	# Link code with runtime and create binary
	#gcc -L./$(LIB_PATH) -o $(OUT_DIR)/$(PROGRAM_NAME) $(OUT_DIR)/main.o -lstark
	# Static link runtime
	gcc -o $(OUT_DIR)/$(PROGRAM_NAME) $(OUT_DIR)/main.o $(LIB_PATH)/libstark.a

test: main
	$(OUT_DIR)/$(PROGRAM_NAME)
