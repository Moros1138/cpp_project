#######################################################
# Project Name (Basis for output file name)
#######################################################
PROJECT     := {{BINARY_NAME}}

#######################################################
# directory structure
#######################################################

BIN         := bin
INC         := include
LIB         := lib
OBJ			:= obj
RES         := res
SRC         := src

inc_flag    := -I$(INC)
lib_flag    := -L$(LIB)

#######################################################
# symbol generation / optimization 
#######################################################
release_mode		:= -O3
debug_mode			:= -ggdb3 -Og

#######################################################
# C++ Source Files
#######################################################
cpp_sources		:= $(wildcard $(SRC)/*.cpp)


#######################################################
# linux dependent stuff
#######################################################
LINUX_CXX		:= g++

# executable output
linux_output	:= $(BIN)/$(PROJECT)

# static link options
linux_static_link	:= -Bstatic -static-libgcc -static-libstdc++
# shared link options
linux_shared_link	:= -static-libstdc++

# flags
linux_cflags		:= -std=c++17 $(release_mode) $(linux_static_link)

# libraries
linux_libraries		:= -lX11 -lGL -lpthread -lpng -lstdc++fs 

# object files derived from source files
linux_objects	:= $(patsubst $(SRC)/%,$(OBJ)/%,$(cpp_sources:.cpp=.linux_x86_64.o))


#######################################################
# windows dependent stuff
#######################################################
WIN_CXX         := i686-w64-mingw32-g++

windows_output	:= $(BIN)/$(PROJECT).exe

# static link options
windows_static_link	:= -Bstatic -static-libgcc -static-libstdc++ -static -s
# shared link options
windows_shared_link	:= -static-libstdc++ -s

# flags
windows_cflags			:= -std=c++17 $(release_mode) $(windows_static_link)

# libraries
windows_libraries	:= -luser32 -lgdi32 -lopengl32 -lgdiplus -lshlwapi -ldwmapi -lstdc++fs

# object files derived from source files
windows_objects	:= $(patsubst $(SRC)/%,$(OBJ)/%,$(cpp_sources:.cpp=.win_x86_64.o))


#######################################################
# finally, the build recipes!
#######################################################
.PHONY: all linux windows clean

all: $(linux_output) $(windows_output)

linux: $(linux_output)

windows: $(windows_output)

# linux compile units
$(OBJ)/%.linux_x86_64.o : $(SRC)/%.cpp
	$(LINUX_CXX) $(linux_cflags) $(inc_flag) -c -o $@ $<

# link linux executable
$(linux_output) : $(linux_objects)
	$(LINUX_CXX) $(linux_cflags) -o $(linux_output) $^ $(linux_libraries) $(lib_flag)

# windows compile units
$(OBJ)/%.win_x86_64.o : $(SRC)/%.cpp
	$(WIN_CXX) $(windows_cflags) $(inc_flag) -c -o $@ $<

# link windows executable
$(windows_output) : $(windows_objects)
	$(WIN_CXX) $(windows_cflags) -o $(windows_output) $^ $(windows_libraries) $(lib_flag)

# remove executables and object files
clean:
	rm -rf $(linux_output) $(windows_output) $(OBJ)/*.o
