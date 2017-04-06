.PHONY: all
.PHONY: clean
.PHONY: run
.PHONY: library

SRC_DIR = src
BASE_LIB_DIR = midi_library
INCLUDE_DIR = $(BASE_LIB_DIR)/include
INCLUDE_FLAG = -I$(INCLUDE_DIR)
OBJECT_DIR = obj
LIBRARY_DIR = $(BASE_LIB_DIR)/lib
LIBRARY_FLAG = -L$(LIBRARY_DIR)
BIN_DIR = bin

OBJ_FILES = ifs.o
BIN_NAME = ifs
LIBRARIES = -lmidi

OBJ = $(patsubst %, $(OBJECT_DIR)/%,$(OBJ_FILES))

BIN = $(BIN_DIR)/$(BIN_NAME)
RUN_ARGS = 100000 < inputs/fern > outputs/fern.pbm

CXX = g++
CXXFLAGS = -std=c++11 $(INCLUDE_FLAG)
LINKFLAGS = $(LIBRARY_FLAG) $(LIBRARIES)

AR = ar
ARFLAGS = rvs

all: $(BIN)

$(OBJECT_DIR):
	mkdir $(OBJECT_DIR)

$(BIN_DIR):
	mkdir $(BIN_DIR)

$(SRC_DIR):
	mkdir $(SRC_DIR)

$(BASE_LIB_DIR):
	git submodule update --init --recursive

library: | $(BASE_LIB_DIR)
	cd midi_library && make

$(INCLUDE_DIR): library

$(LIBRARY_DIR): library

$(OBJECT_DIR)/%.o: $(SRC_DIR)/%.cpp $(OBJECT_DIR) $(BIN_DIR) | $(INCLUDE_DIR)
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(BIN): $(OBJ) | $(LIBRARY_DIR)
	$(CXX) -o $@ $^ $(LINKFLAGS)

run:  $(BIN)
	$(BIN) $(RUN_ARGS)

clean:
	rm -rf $(OBJECT_DIR)
	rm -rf $(BIN_DIR)

clean-all: clean
	rm -rf $(BASE_LIB_DIR)
