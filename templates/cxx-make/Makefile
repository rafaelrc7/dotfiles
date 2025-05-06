######################### Preamble ###########################################
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.SECONDEXPANSION:
.EXTRA_PREREQS := $(MAKEFILE_LIST)
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += -j$(shell nproc)

######################### Project Settings ###################################

# Default target debug/release
all: debug

# TARGETS
#	BIN_TARGETS := list of executable targets installed at ./bin
#	LIB_TARGETS := list of library targets installed at ./lib. Must include
#		.so/.a extension
BIN_TARGETS := hello goodbye
LIB_TARGETS := libhello.a libgoodbye.so

# TARGET source files
#	<TARGET>_SRCS := list of source files
hello_SRCS := ./src/hello.c
goodbye_SRCS := ./src/goodbye.c
libhello.a_SRCS := ./src/libhello.c
libgoodbye.so_SRCS := ./src/libgoodbye.c

# Extra optional variables
#	<TARGET>_OBJS := list of target specific link objects, such as static libraries
#	<TARGET>_ARFLAGS := list of target specific ARFLAGS
#	<TARGET>_LDFLAGS := list of target specific LDFLAGS, such as libraries
#	<TARGET>_LDLIBS := list of target specific LDLIBS, such as libraries
#	<TARGET>_CPPFLAGS := list of target specific CPPFLAGS
#	<TARGET>_CXXFLAGS := list of target specific CXXFLAGS
#	<TARGET>_CFLAGS := list of target specific CFLAGS
#	<TARGET>_ASFLAGS := list of target specific ASFLAGS
hello_OBJS := ./lib/libhello.a
goodbye_LDLIBS := -lgoodbye

# Default tool to use to link binaries and shared libraries
LINK ?= $(CC)

# TARGET specific link tool
#	<TARGET>_LINK := compiler eg. $(CXX)

# General Flags
CPPFLAGS ?= -Wall -Wextra -pedantic
CXXFLAGS ?= -std=c++17
CFLAGS ?= -std=c17 -Werror=vla
ASFLAGS ?=
ARFLAGS ?=
LDFLAGS ?=
LDLIBS ?=

# General Profile Flags
CPPFLAGS_DEBUG ?= -ggdb -O0 -fsanitize=address,leak,undefined
CPPFLAGS_RELEASE ?= -DNDEBUG -O2 -flto
LDFLAGS_DEBUG ?= -fsanitize=address,leak,undefined
LDFLAGS_RELEASE ?= -flto=auto

# Build Directories
INC_DIR := ./include
BIN_DIR := ./bin
LIB_DIR := ./lib
AUX_DIR := ./build

# Project source dir
srcdir := ./src

# Install Directories
DESTDIR ?= /
prefix ?= /usr/local
exec_prefix ?= $(prefix)
bindir ?= $(exec_prefix)/bin
libdir ?= $(exec_prefix)/lib
datarootdir ?= $(prefix)/share
datadir ?= $(datarootdir)
sysconfdir ?= $(prefix)/etc
sharedstatedir ?= $(prefix)/com
localstatedir ?= $(prefix)/var
runstatedir ?= $(localstatedir)/run
includedir ?= $(prefix)/include

###############################################################################
###############################################################################

# Targets
TARGETS := $(BIN_TARGETS) $(LIB_TARGETS)
$(BIN_TARGETS): $(BIN_DIR)/$$@
$(LIB_TARGETS): $(LIB_DIR)/$$@
BINS := $(addprefix $(BIN_DIR)/,$(BIN_TARGETS))
LIBS := $(addprefix $(LIB_DIR)/,$(LIB_TARGETS))

# Source Files
SRCS = $(foreach TARGET,$(TARGETS),$($(TARGET)_SRCS))
TARGET_OBJS = $$(addprefix $(AUX_DIR)/$$(@F)/,$$(addsuffix .o,$$($$(@F)_SRCS))) $$($$(@F)_OBJS)
SRC_DIRS := $(shell find $(srcdir) -type d)
BUILD_SRC_DIRS := $(foreach TARGET,$(TARGETS),$(addprefix $(AUX_DIR)/$(TARGET)/,$(SRC_DIRS)))
AUX_DIRS := $(foreach TARGET,$(TARGETS),$(addsuffix /$(TARGET),$(AUX_DIR)))

# Flags
INC_FLAG := $(addprefix -I,$(INC_DIR))
LIB_FLAG := $(addprefix -L,$(LIB_DIR))

CPPFLAGS += $(INC_FLAG)
LDFLAGS += $(LIB_FLAG)

# Profiles
debug: CPPFLAGS += $(CPPFLAGS_DEBUG)
debug: LDFLAGS  += $(LDFLAGS_DEBUG)
debug: $(TARGETS) | $(INC_DIR)

release: CPPFLAGS += $(CPPFLAGS_RELEASE)
release: LDFLAGS  += $(LDFLAGS_RELEASE)
release: $(TARGETS) | $(INC_DIR)

# Set optional variables default value to empty string
$(foreach VAR,LINK OBJS LDFLAGS LDLIBS ARFLAGS CPPFLAGS CXXFLAGS CFLAGS ASFLAGS,\
	$(foreach TARGET,$(TARGETS),\
		$(eval $(TARGET)_$(VAR)?=)))

# Binaries
$(BINS): $(TARGET_OBJS) | $(BIN_DIR) $(LIBS)
	$(or $($(@F)_LINK),$(LINK)) -o $@ $^ $(LDFLAGS) $($(@F)_LDFLAGS) $(LDLIBS) $($(@F)_LDLIBS)

# Libraries
$(LIB_DIR)/%.so: CPPFLAGS += -fPIC
$(LIB_DIR)/%.so: $(TARGET_OBJS) | $(LIB_DIR)
	$(or $($(@F)_LINK),$(LINK)) -o $@ -shared $^ $(LDFLAGS) $($(@F)_LDFLAGS) $(LDLIBS) $($(@F)_LDLIBS)

$(LIB_DIR)/%.a: $(TARGET_OBJS) | $(LIB_DIR)
	$(AR) $(ARFLAGS) $($(@F)_ARFLAGS) $@ $?

# Dependency files
-include $(foreach TARGET,$(TARGETS),$($(TARGET)_SRCS:%=$(AUX_DIR)/$(TARGET)/%.d))

# Each target has its own build folder, making it possible to build the same
# source file with different flags for different targets. Also makes sure to
# pass target specific flags to its files
define objs
# C header dependency files
$$(AUX_DIR)/$(TARGET)/%.c.d: %.c | $$(BUILD_SRC_DIRS)
	@$$(CC) $$(CFLAGS) $$($(TARGET)_CFLAGS) $$(CPPFLAGS) $$($(TARGET)_CPPFLAGS) $$< -MM -MT $$(@:%.c.d=%.c.o) >$$@

# C object files
$$(AUX_DIR)/$(TARGET)/%.c.o: %.c | $$(BUILD_SRC_DIRS)
	$$(CC) -o $$@ $$(CFLAGS) $$($(TARGET)_CFLAGS) $$(CPPFLAGS) $$($(TARGET)_CPPFLAGS) -c $$<

# C++ header dependency files
$$(AUX_DIR)/$(TARGET)/%.cpp.d: %.cpp | $$(BUILD_SRC_DIRS)
	@$$(CXX) $$(CXXFLAGS) $$($(TARGET)_CXXFLAGS) $$(CPPFLAGS) $$($(TARGET)_CPPFLAGS) $$< -MM -MT $$(@:%.cpp.d=%.cpp.o) >$$@

# C++ object files
$$(AUX_DIR)/$(TARGET)/%.cpp.o: %.cpp | $$(BUILD_SRC_DIRS)
	$$(CXX) -o $$@ $$(CXXFLAGS) $$($(TARGET)_CXXFLAGS) $$(CPPFLAGS) $$($(TARGET)_CPPFLAGS) -c $$<

# ASM object files
$$(AUX_DIR)/$(TARGET)/%.s.o: %.s | $$(BUILD_SRC_DIRS)
	$$(AS) -o $$@ $$(ASFLAGS) $$($(TARGET)_ASFLAGS) -c $$<

$$(AUX_DIR)/$(TARGET)/%.S.o: $$(AUX_DIR)/$(TARGET)/%.S.s | $$(BUILD_SRC_DIRS)
	$$(AS) -o $$@ $$(ASFLAGS) $$($(TARGET)_ASFLAGS) -c $$<

$$(AUX_DIR)/$(TARGET)/%.S.s: %.S | $$(BUILD_SRC_DIRS)
	$$(CC) -o $$@ $$(CPPFLAGS) $$($(TARGET)_CPPFLAGS) -E $$<
endef
$(foreach TARGET,$(TARGETS),$(eval $(call objs)))

# Directories
$(AUX_DIR) $(BUILD_SRC_DIRS) $(BIN_DIR) $(LIB_DIR) $(INC_DIR):
	@$(MKDIR_P) $@

# Compiledb
compiledb: compile_commands.json

compile_commands.json: Makefile $(SRCS)
	+bear -- make --always-make --no-silent

# Utilities
clean:
	-$(RM_R) compile_commands.json
	-$(RM_R) "$(AUX_DIR)"
	-$(RM_R) "$(BIN_DIR)"
	-$(RM_R) "$(LIB_DIR)"

install: release
	find "$(BIN_DIR)" -type f \
		-exec install -Dm755 "{}" -t "$(DESTDIR)$(bindir)" \;
	find "$(LIB_DIR)" -type f \
		-exec install -Dm755 "{}" -t "$(DESTDIR)$(libdir)" \;
	find "$(INC_DIR)" -type f \( -iname "*.hpp" -or -iname "*.h" \) \
		-exec install -Dm644 "{}" "$(DESTDIR)$(prefix)/{}" \;

install-strip: release
	find "$(BIN_DIR)" -type f \
		-exec install -Dsm755 "{}" -t "$(DESTDIR)$(bindir)" \;
	find "$(LIB_DIR)" -type f \
		-exec install -Dsm755 "{}" -t "$(DESTDIR)$(libdir)" \;
	find "$(INC_DIR)" -type f \( -iname "*.hpp" -or -iname "*.h" \) \
		-exec install -Dm644 "{}" "$(DESTDIR)$(prefix)/{}" \;

uninstall:
	-find "$(BIN_DIR)" -type f \
		-exec rm "$(DESTDIR)$(prefix)/{}" \;
	-find "$(LIB_DIR)" -type f \
		-exec rm "$(DESTDIR)$(prefix)/{}" \;
	-find "$(INC_DIR)" -type f \( -iname "*.hpp" -or -iname "*.h" \) \
		-exec rm "$(DESTDIR)$(prefix)/{}" \;
	-find "$(INC_DIR)" -type d -regex "$(INC_DIR)/.+" \
		-exec rmdir "$(DESTDIR)$(prefix)/{}" \;

fmt:
	find $(srcdir) -iname "*.h" -or -iname "*.hpp" -or -iname "*.c" -or -iname "*.cpp" |\
		xargs clang-format -i

tidy: compiledb
	find $(srcdir) -iname "*.cpp" -or -iname "*.c" |\
		xargs run-clang-tidy -j`nproc` -config-file ./.clang-tidy -p . -fix -format

MKDIR_P ?= mkdir -p
RM_R ?= $(RM) -r

.PHONY: all debug release clean compiledb install install-strip uninstall fmt tidy $(TARGETS)

