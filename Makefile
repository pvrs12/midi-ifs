.PHONY: all
.PHONY: clean
.PHONY: run

SRC_DIR = src
INCLUDE_DIRS = -Iinclude
OBJECT_DIR = obj
LIBRARY_DIRS = -Llib
BIN_DIR = bin

OBJ_FILES = ifs.o
BIN_NAME = ifs
LIBRARIES = -lmidi

OBJ = $(patsubst %, $(OBJECT_DIR)/%,$(OBJ_FILES))

BIN = $(BIN_DIR)/$(BIN_NAME)
RUN_ARGS = 100000 < inputs/fern > outputs/fern.pbm

CXX = g++
CXXFLAGS = -std=c++11 $(INCLUDE_DIRS)
LINKFLAGS = $(LIBRARY_DIRS) $(LIBRARIES)

AR = ar
ARFLAGS = rvs

all: $(BIN)

$(OBJECT_DIR):
	mkdir $(OBJECT_DIR)

$(BIN_DIR):
	mkdir $(BIN_DIR)

$(SRC_DIR):
	mkdir $(SRC_DIR)

$(OBJECT_DIR)/%.o: $(SRC_DIR)/%.cpp $(OBJECT_DIR) $(BIN_DIR)
	$(CXX) -c $(CXXFLAGS) -o $@ $<

$(BIN): $(OBJ)
	$(CXX) -o $@ $^ $(LINKFLAGS)

run:  $(BIN)
	$(BIN) $(RUN_ARGS)

clean:
	rm -rf obj
	rm -rf bin
