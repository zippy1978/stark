all: test

ROOT_DIR = $(realpath .)
OUT_DIR = bin
DEPS_DIR = dependencies
SRC_DIR = src
CC = llvm-g++
FLEX = /usr/local/opt/flex/bin/flex
BISON = /usr/local/opt/bison/bin/bison

LLVMCONFIG = /usr/local/opt/llvm/bin/llvm-config
#CPPFLAGS = `${LLVMCONFIG} --cppflags` -std=c++11 -I/usr/local/opt/flex/include
#LDFLAGS = `${LLVMCONFIG} --ldflags` -lpthread -ldl -lz -lncurses -rdynamic -L/usr/local/opt/flex/lib
#LIBS = `${LLVMCONFIG} --libs`

LDFLAGS="-L/usr/local/opt/flex/lib"
CPPFLAGS="-I/usr/local/opt/flex/include"

deps:
	@mkdir -p $(DEPS_DIR)
	@if [ ! -d $(DEPS_DIR)/bdwgc ]; then \
		mkdir -p $(DEPS_DIR)/bdwgc; \
        git clone git://github.com/ivmai/bdwgc.git $(DEPS_DIR)/bdwgc; \
		cd $(DEPS_DIR)/bdwgc && cmake . -DBUILD_SHARED_LIBS=OFF && make; \
	else \
		echo "bdwgc already installed : skipping"; \
    fi

generate:
	$(FLEX) -o $(SRC_DIR)/parser/tokens.cpp $(SRC_DIR)/parser/tokens.l
	$(BISON) -d -o $(SRC_DIR)/parser/parser.cpp $(SRC_DIR)/parser/parser.y


stark: deps generate
	mkdir -p $(OUT_DIR)
	$(CC) -g -O3 -o $(OUT_DIR)/stark `$(LLVMCONFIG) --cxxflags --ldflags --system-libs --libs all` $(CPPFLAGS) $(LDFLAGS) $(DEPS_DIR)/bdwgc/libgc.a $(SRC_DIR)/util/*.cpp $(SRC_DIR)/runtime/*.cpp $(SRC_DIR)/ast/*.cpp $(SRC_DIR)/parser/*.cpp $(SRC_DIR)/compiler/*.cpp $(SRC_DIR)/codeGen/*.cpp $(SRC_DIR)/codeGen/types/*.cpp $(SRC_DIR)/stark.cpp

starkc: generate
	mkdir -p $(OUT_DIR)
	$(CC) -g -O3 -o $(OUT_DIR)/starkc `$(LLVMCONFIG) --cxxflags --ldflags --system-libs --libs all` $(CPPFLAGS) $(LDFLAGS) $(SRC_DIR)/util/*.cpp $(SRC_DIR)/ast/*.cpp $(SRC_DIR)/parser/*.cpp $(SRC_DIR)/compiler/*.cpp $(SRC_DIR)/codeGen/*.cpp $(SRC_DIR)/codeGen/types/*.cpp $(SRC_DIR)/starkc.cpp

runtime: deps
	mkdir -p $(OUT_DIR)/libstark
	$(CC) -g -c $(SRC_DIR)/runtime/IO.cpp -o $(OUT_DIR)/libstark/io.o
	$(CC) -g -c $(SRC_DIR)/runtime/Conversion.cpp -o $(OUT_DIR)/libstark/conversion.o
	$(CC) -g -c $(SRC_DIR)/runtime/Memory.cpp -o $(OUT_DIR)/libstark/memory.o
	$(CC) -shared -o $(OUT_DIR)/libstark.so $(OUT_DIR)/libstark/io.o $(OUT_DIR)/libstark/conversion.o $(OUT_DIR)/libstark/memory.o $(DEPS_DIR)/bdwgc/libgc.a
	cd $(OUT_DIR)/libstark && ar -x ../../$(DEPS_DIR)/bdwgc/libgc.a
	ar rcs $(OUT_DIR)/libstark.a  $(OUT_DIR)/libstark/*.o

clean:
	# Remove generated source files
	rm -f $(SRC_DIR)/parser/*.hh $(SRC_DIR)/parser/*.hpp $(SRC_DIR)/parser/parser.cpp $(SRC_DIR)/parser/tokens.cpp
	rm -rf $(OUT_DIR)
	rm -rf $(DEPS_DIR)

test_lang: stark
	./$(OUT_DIR)/stark -d test/comments.st
	./$(OUT_DIR)/stark -d test/variables/declaration.st
	./$(OUT_DIR)/stark -d test/variables/assignment.st
	./$(OUT_DIR)/stark -d test/functions/declaration.st
	./$(OUT_DIR)/stark -d test/functions/call.st
	./$(OUT_DIR)/stark -d test/functions/external.st
	./$(OUT_DIR)/stark -d test/expressions/binary.st
	./$(OUT_DIR)/stark -d test/expressions/comparison.st
	./$(OUT_DIR)/stark -d test/expressions/conversion.st
	./$(OUT_DIR)/stark -d test/statements/ifelse.st
	./$(OUT_DIR)/stark -d test/statements/while.st
	./$(OUT_DIR)/stark -d test/types/string.st
	./$(OUT_DIR)/stark -d test/structs/declaration.st
	./$(OUT_DIR)/stark -d test/structs/assignment.st
	./$(OUT_DIR)/stark -d test/arrays/declaration.st
	./$(OUT_DIR)/stark -d test/arrays/assignment.st
	./$(OUT_DIR)/stark -d test/interpreter/args.st arg1 arg2

test_interpreter: stark
	@./$(OUT_DIR)/stark -d test/interpreter/return.st && exit 1 || echo "expected return failure"

test_compiler: starkc runtime
	@cd $(ROOT_DIR)/test/compiler/singlefile && make

test: test_lang test_interpreter test_compiler

scratch:
	./$(OUT_DIR)/stark -d test/scratchpad.st
