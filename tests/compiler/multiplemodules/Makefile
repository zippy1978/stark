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

#SANITIZER_FLAGS:=-fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer -g -O1
SANITIZER_FLAGS:=

clean:
	rm -rf $(OUT_DIR)/modules/product
	rm -rf $(OUT_DIR)/modules/company

product_module: clean
	mkdir -p $(OUT_DIR)/modules
	$(STARKC) -d -o $(OUT_DIR)/modules product/functions.st product/types.st


company_module: product_module
	mkdir -p $(OUT_DIR)/modules
	$(STARKC) -d -o $(OUT_DIR)/modules company/functions.st company/types.st

main: company_module
	$(STARKC) -d -r $(LIB_PATH)/libstark.a -o $(OUT_DIR)/$(PROGRAM_NAME) main.st

test: main
	$(OUT_DIR)/$(PROGRAM_NAME)
