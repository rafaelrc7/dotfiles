# Preamble
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += -j$(shell nproc)

# Default target debug/release
all: debug

# Executables
TARGETS := hello

# Install Prefix
PREFIX ?= /usr/local

# Assembler/Compilers
CXX ?= g++
CC ?= gcc
AS ?= as
LINK ?= $(CC)

# Flags
CPPFLAGS ?= -Wall -Wextra -pedantic
CXXFLAGS ?= -std=c++17
CFLAGS ?= -std=c17 -Werror=vla
ASFLAGS ?=
LDFLAGS ?=

CPPFLAGS_DEBUG += -ggdb -O0
CPPFLAGS_RELEASE += -DNDEBUG -O2 -flto
LDFLAGS_DEBUG +=
LDFLAGS_RELEASE += -flto=auto -s

# Directories
INC_DIR := ./include
BUILD_DIR := ./build
BIN_DIR := ./bin

# Executables settings
HELLO_SRC_DIR := ./src

HELLO_SRCS := $(shell find $(HELLO_SRC_DIR) -type f -name *.c -or -name *.cpp -or -name *.s)
HELLO_OBJS := $(HELLO_SRCS:%=$(BUILD_DIR)/%.o)
HELLO_DEPS := $(HELLO_OBJS:.o=.d)

$(BIN_DIR)/hello: $(HELLO_OBJS) | $(BIN_DIR)

-include $(HELLO_DEPS)

# Compile commands
compile_commands.json: Makefile $(HELLO_SRCS)
	+bear -- make --always-make --no-silent

###############################################################################

EXECUTABLES := $(addprefix $(BIN_DIR)/,$(TARGETS))

BUILD_SRC_DIRS := $(addprefix $(BUILD_DIR)/,$(shell find ./src -type d))

INC_FLAG := $(addprefix -I,$(INC_DIR))

debug: CPPFLAGS += $(CPPFLAGS_DEBUG)
debug: LDFLAGS  += $(LDFLAGS_DEBUG)
debug: $(EXECUTABLES)

release: CPPFLAGS += $(CPPFLAGS_RELEASE)
release: LDFLAGS  += $(LDFLAGS_RELEASE)
release: $(EXECUTABLES) | $(INC_DIR)

# Executables
$(BIN_DIR)/%: | $(BIN_DIR)
	$(LINK) $^ -o $@ $(LDFLAGS)

# ASM object files
$(BUILD_DIR)/%.s.o: %.s | $(BUILD_SRC_DIRS)
	$(AS) $(ASFLAGS) $(CPPFLAGS) $(INC_FLAG) -c $< -o $@

# C object files
$(BUILD_DIR)/%.c.o: %.c | $(BUILD_SRC_DIRS)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(INC_FLAG) -c $< -o $@
# C++ object files
$(BUILD_DIR)/%.cpp.o: %.cpp | $(BUILD_SRC_DIRS)
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(INC_FLAG) -c $< -o $@

# C++ header dependency files
$(BUILD_DIR)/%.cpp.d: %.cpp | $(BUILD_SRC_DIRS)
	@$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(INC_FLAG) $< -MM -MT $(@:%.cpp.d=%.cpp.o) >$@

# C header dependency files
$(BUILD_DIR)/%.c.d: %.c | $(BUILD_SRC_DIRS)
	@$(CC) $(CFLAGS) $(CPPFLAGS) $(INC_FLAG) $< -MM -MT $(@:%.c.d=%.c.o) >$@

# Directories
$(BUILD_DIR) $(BUILD_SRC_DIRS) $(BIN_DIR) $(INC_DIR):
	@$(MKDIR_P) $@

compiledb: compile_commands.json

clean:
	-$(RM_R) compile_commands.json
	-$(RM_R) "$(BUILD_DIR)"
	-$(RM_R) "$(BIN_DIR)"

install: release
	find "$(EXECUTABLES)" -type f \
		-exec install -Dm755 "{}" -t "$(PREFIX)/bin" \;
	find "$(INC_DIR)" -type f \( -iname "*.hpp" -or -iname "*.h" \) \
		-exec install -Dm644 "{}" "$(PREFIX)/{}" \;

uninstall:
	-find "$(EXECUTABLES)" -type f \
		-exec rm "$(PREFIX)/{}" \;
	-find "$(INC_DIR)" -type f \( -iname "*.hpp" -or -iname "*.h" \) \
		-exec rm "$(PREFIX)/{}" \;
	-find "$(INC_DIR)" -type d -regex "$(INC_DIR)/.+" \
		-exec rmdir "$(PREFIX)/{}" \;

fmt:
	find ./src -iname *.h -or -iname *.hpp -or -iname *.c -or -iname *.cpp | xargs clang-format -i

tidy: compiledb
	find ./src -iname *.cpp -or iname *.c |\
		xargs run-clang-tidy -j`nproc` -config-file ./.clang-tidy -p . -fix -format

MKDIR_P ?= mkdir -p
RM_R ?= rm -r

.PHONY: all debug release clean compiledb install uninstall fmt

