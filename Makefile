# =============================================================================
# Basic template makefile for libraries.
# $Id$
#
# *** IMPORTANT NOTES -- READ THESE FIRST ***
#     1) This file _requires_ the use of GNU make (gmake).
# =============================================================================

DZR_BASE_DIR=	.

# Nothing but comments should come before this line.
default: all
OBJDIR=objs
DEPDIR=deps

# -----------------------------------------------------------------------------
# Application-specific variable settings.  It is safe to modify these.
# -----------------------------------------------------------------------------

# The base name of the library that is built.  A value must be set for this!
# The platform-specific extensions for shared libraries and static libraries
# are appended below.
LIB_NAME=	cppdom

# The directory where the source files for this library are located.
srcdir=  	cppdom

# Set a langauge for compiling.  This is optional and will default to C++ if
# nothing is specified.  Currently supported langauges are C and C++.
#LANGUAGE=	

# Compiler flags needed for this library.  They are used as follows:
#
#    DEBUG_APP         - If set to TRUE, this librar will be compiled with
#                        debugging symbols and no optimized symbols
#    OPTIM_APP         - If set to TRUE, this librar will be compiled with
#                        optimized symbols and no debugging symbols
#    EXTRA_CFLAGS      - Extra librar-specific C compiler flags
#    EXTRA_CXXFLAGS    - Extra librar-specific C++ compiler flags
#    EXTRA_DEBUG_FLAGS - Extra librar-specific compiler debugging flags
#    EXTRA_INCLUDES    - Extra include paths (-I... options) for the compilers
#    EXTRA_OPTIM_FLAGS - Extra librar-specific compiler optimization flags
#    EXTRA_UI_LIBS     - Extra user interface libraries needed for linking.
#
DEBUG_APP=		TRUE
OPTIM_APP=		FALSE
EXTRA_CFLAGS=		
EXTRA_CXXFLAGS=		
EXTRA_DEBUG_FLAGS=	
EXTRA_INCLUDES=		-I.
EXTRA_OPTIM_FLAGS=	
EXTRA_UI_FLAGS=		

# The list of all source files needed for this librar.  Based on this, a list
# of object files is put in $(OBJS) automatically.
SRCS=	xmlparser.cpp xmltokenizer.cpp cppdom.cpp		

# This is for extra libraries needed specfically for your library.  The
# general libraries needed for library are in $(LIBS).
EXTRA_LIBS=		

# This is for extra system libraries (-lpthread for example) needed
# specifically for this library.  These are added to the linker command
# after all the basic libraries and all the system libraries.
EXTRA_SYS_LIBS=		

# Extend this as necessary to find source files that are not in the current
# directory.  Set EXTRA_PATH_FOR_SOURCES to all the directories that you
# have sources in. (current dir is already included by default)
EXTRA_PATH_FOR_SOURCES=	

# Additional files and directories besides the standard ones that need to be
# removed by the 'clean' target.
CLEAN_FILES=		
CLEAN_DIRS=		

# The following include line MUST COME BEFORE the targets for compiling the
# library.
#
# To build a library, include the following basic file:
#
#     dzr.lib.mk - An ordinary software library
#
include $(DZR_BASE_DIR)/mk/dzr.lib.mk

# -----------------------------------------------------------------------------
# Targets.
# -----------------------------------------------------------------------------
SHARED_LIB_FILENAME=$(SHLIB_PREFIX)$(LIB_NAME)$(SHLIB_EXT) 
STATIC_LIB_FILENAME=$(LIB_PREFIX)$(LIB_NAME)$(LIB_EXT)
all: $(SHARED_LIB_FILENAME) $(STATIC_LIB_FILENAME)

tests:
	-cd test && ${MAKE}

# Target for the shared library to be built.
$(SHARED_LIB_FILENAME): $(OBJS)
	$(SHARED_LINK) -o $@ $(OBJS)

# Target for the static library to be built.
$(STATIC_LIB_FILENAME): $(OBJS)
	$(STATIC_LINK) $@ $(OBJS)

# TODO: edit this to install your files... 
#        - determine if you need all the dirs (bin, share, lib, include)
#        - append cp or install commands for your .h, lib files...
#        - prefix is your install path, edit it to specify the default
prefix ?= installed
INSTALLCMD=./install-sh
install: all tests
	-$(INSTALLCMD) -d $(prefix)/include
	-$(INSTALLCMD) -d $(prefix)/include/$(LIB_NAME)
	-$(INSTALLCMD) -d $(prefix)/lib$(LIBBITSUF)
	-$(INSTALLCMD) -d $(prefix)/share/$(LIB_NAME)
	-$(INSTALLCMD) -d $(prefix)/bin
	-cp $(LIB_NAME)/*.h $(prefix)/include/$(LIB_NAME)
	-cp $(SHARED_LIB_FILENAME) $(STATIC_LIB_FILENAME) $(prefix)/lib$(LIBBITSUF)
	-cp test/predtest test/nodetest test/parsetest test/*.xml $(prefix)/share/$(LIB_NAME)

CLOBBER_FILES += $(SHARED_LIB_FILENAME) $(STATIC_LIB_FILENAME)
