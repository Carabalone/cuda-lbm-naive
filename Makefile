# Compiler and flags
CXX = g++
NVCC = nvcc
CXXFLAGS = -O3 -std=c++17
NVCCFLAGS = -O3 -std=c++14

# Directories
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin

# Output binary
TARGET = $(BIN_DIR)/cuda-lbm

# Source files
CXX_SRCS = $(wildcard $(SRC_DIR)/*.cpp)
CUDA_SRCS = $(wildcard $(SRC_DIR)/*.cu)

# Object files
CXX_OBJS = $(CXX_SRCS:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)
CUDA_OBJS = $(CUDA_SRCS:$(SRC_DIR)/%.cu=$(OBJ_DIR)/%.o)

# Rules
all: $(TARGET)

$(TARGET): $(CXX_OBJS) $(CUDA_OBJS)
	$(NVCC) $(CXX_OBJS) $(CUDA_OBJS) -o $@ $(NVCCFLAGS)

# Compile C++ files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Compile CUDA files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cu
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

# Clean up
clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET)

.PHONY: clean all

run: $(TARGET)
	@echo "Running $(TARGET)..."
	@$(TARGET)
