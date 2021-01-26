all: test

ROOT_DIR = $(realpath .)
OUT_DIR = bin
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

generate:
	$(FLEX) -o $(SRC_DIR)/parser/tokens.cpp $(SRC_DIR)/parser/tokens.l
	$(BISON) -d -o $(SRC_DIR)/parser/parser.cpp $(SRC_DIR)/parser/parser.y


stark: generate
	mkdir -p $(OUT_DIR)
	$(CC) -g -O3 -o $(OUT_DIR)/stark `$(LLVMCONFIG) --cxxflags --ldflags --system-libs --libs all` $(CPPFLAGS) $(LDFLAGS) $(SRC_DIR)/util/*.cpp $(SRC_DIR)/runtime/*.cpp $(SRC_DIR)/ast/*.cpp $(SRC_DIR)/parser/*.cpp $(SRC_DIR)/codeGen/*.cpp $(SRC_DIR)/codeGen/types/*.cpp $(SRC_DIR)/stark.cpp

starkc: generate
	mkdir -p $(OUT_DIR)
	$(CC) -g -O3 -o $(OUT_DIR)/starkc `$(LLVMCONFIG) --cxxflags --ldflags --system-libs --libs all` $(CPPFLAGS) $(LDFLAGS) $(SRC_DIR)/util/*.cpp $(SRC_DIR)/ast/*.cpp $(SRC_DIR)/parser/*.cpp $(SRC_DIR)/codeGen/*.cpp $(SRC_DIR)/codeGen/types/*.cpp $(SRC_DIR)/starkc.cpp

runtime: 
	$(CC) -g -c $(SRC_DIR)/runtime/IO.cpp -o $(OUT_DIR)/io.o
	$(CC) -g -c $(SRC_DIR)/runtime/Convert.cpp -o $(OUT_DIR)/convert.o
	$(CC) -shared -o $(OUT_DIR)/libstark.so $(OUT_DIR)/io.o $(OUT_DIR)/convert.o
	ar rcs $(OUT_DIR)/libstark.a $(OUT_DIR)/io.o $(OUT_DIR)/convert.o

clean:
	# Remove generated source files
	rm $(SRC_DIR)/parser/*.hh $(SRC_DIR)/parser/*.hpp $(SRC_DIR)/parser/parser.cpp $(SRC_DIR)/parser/tokens.cpp
	rm -rf $(OUT_DIR)

test_lang: stark
	./$(OUT_DIR)/stark -d test/comments.st
	./$(OUT_DIR)/stark -d test/variables/declaration.st
	./$(OUT_DIR)/stark -d test/variables/assignment.st
	./$(OUT_DIR)/stark -d test/functions/declaration.st
	./$(OUT_DIR)/stark -d test/functions/call.st
	./$(OUT_DIR)/stark -d test/functions/external.st
	./$(OUT_DIR)/stark -d test/expressions/binary.st
	./$(OUT_DIR)/stark -d test/expressions/comparison.st
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
