cmake_minimum_required(VERSION 3.18)

# Enable new optimized variable evaluation
cmake_policy(SET CMP0053 NEW)

# Enable the next line to see the actual commands run when building etc.
set(CMAKE_VERBOSE_MAKEFILE ON)

# Log active toolchain
message(STATUS "Using toolchain file: ${CMAKE_TOOLCHAIN_FILE}")

# Set the default search path for modules when using include / find_package
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
message(STATUS "Using C compiler: " ${CMAKE_C_COMPILER})
message(STATUS "Using C++ compiler: " ${CMAKE_CXX_COMPILER})

# PROJECT #
if(NOT DEFINED ENV{PROJECT})
    message(FATAL_ERROR "Please set PROJECT in your environment")
endif()
project("$ENV{PROJECT}")

# Compiler Flags
set(warning_flags "-Winline -Wall -Wextra")
set(cpp_flags "-fno-rtti -fno-exceptions")
set(debug_flags "-O0 -g -DDEBUG")
set(release_flags "-O3 -fomit-frame-pointer -ffast-math")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS} ${warning_flags} ${debug_flags}")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS} ${warning_flags} ${cpp_flags} ${debug_flags}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS} ${warning_flags} ${release_flags}")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS} ${warning_flags} ${cpp_flags} ${release_flags}")

## PROJECT - CODE #
set(SOURCE_TARGET_NAME "source")

include(gamecube.macro)
add_subdirectory(source)

# from gamecube_rules
##---------------------------------------------------------------------------------
#%.dol: %.elf
#$(SILENTMSG) output ... $(notdir $@)
#$(SILENTCMD)elf2dol $< $@
#
##---------------------------------------------------------------------------------
#%.tpl : %.scf
#$(SILENTMSG) $(notdir $<)
#$(SILENTCMD)gxtexconv -s $< -d $(DEPSDIR)/$*.d -o $@
#
##---------------------------------------------------------------------------------
#%.elf:
#$(SILENTMSG) linking ... $(notdir $@)
#$(ADD_COMPILE_COMMAND) end
#$(SILENTCMD)$(LD)  $^ $(LDFLAGS) $(LIBPATHS) $(LIBS) -o $@

# bin2o from base_tools:
##---------------------------------------------------------------------------------
## canned command sequence for binary data
##---------------------------------------------------------------------------------
#define bin2o
#$(eval _tmpasm := $(shell mktemp))
#$(SILENTCMD)bin2s -a 32 -H `(echo $(<F) | tr . _)`.h $< > $(_tmpasm)
#$(SILENTCMD)$(CC) -x assembler-with-cpp $(CPPFLAGS) $(ASFLAGS) -c $(_tmpasm) -o $(<F).o
#@rm $(_tmpasm)
#endef