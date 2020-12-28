all: test

OUT_DIR = bin
SRC_DIR = src

LLVMCONFIG = /usr/local/opt/llvm/bin/llvm-config
#CPPFLAGS = `${LLVMCONFIG} --cppflags` -std=c++11 -I/usr/local/opt/flex/include
#LDFLAGS = `${LLVMCONFIG} --ldflags` -lpthread -ldl -lz -lncurses -rdynamic -L/usr/local/opt/flex/lib
LIBS = `${LLVMCONFIG} --libs`

LDFLAGS="-L/usr/local/opt/flex/lib"
CPPFLAGS="-I/usr/local/opt/flex/include"

#`$LLVM_PATH/llvm-config --libs core executionengine interpreter mc support nativecodegen --cxxflags --ldflags`

stark: bison
	g++ -g -O3 -o $(OUT_DIR)/stark `$(LLVMCONFIG) --libs core  executionengine interpreter mc support nativecodegen --cxxflags --ldflags` $(CPPFLAGS) $(LDFLAGS) $(SRC_DIR)/*.cc
	#echo $(LIBS)
	#g++ -g -O3 -o $(OUT_DIR)/stark $(CPPFLAGS) $(LDFLAGS) $(SRC_DIR)/*.cc

bison: flex
	/usr/local/opt/bison/bin/bison -d -o $(SRC_DIR)/parser.cc $(SRC_DIR)/parser.y

flex:
	/usr/local/opt/flex/bin/flex -o $(SRC_DIR)/tokens.cc $(SRC_DIR)/tokens.l

clean:
	rm -rf $(OUT_DIR)/*
	rm $(SRC_DIR)/parser.cc $(SRC_DIR)/parser.hh $(SRC_DIR)/tokens.cc $(SRC_DIR)/location.hh $(SRC_DIR)/position.hh

test: stark
	./$(OUT_DIR)/stark test/comments.st
	./$(OUT_DIR)/stark test/variables/declaration.st
	./$(OUT_DIR)/stark test/functions/declaration.st
	./$(OUT_DIR)/stark test/functions/call.st