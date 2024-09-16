cmake_minimum_required(VERSION 3.18)

# Enable new optimized variable evaluation
cmake_policy(SET CMP0053 NEW)

# Enable the next line to see the actual commands run when building etc.
set(CMAKE_VERBOSE_MAKEFILE ON)

# Log active toolchain
message(STATUS "Using toolchain file: ${CMAKE_TOOLCHAIN_FILE}")

option(WII_TARGET "Choose the Wii target instead of the gamecube one" FALSE)

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
include_directories("include")

# PROJECT - ASSETS #
#set(ASSETS_PATH "${CMAKE_SOURCE_DIR}/assets")
#set(ASSETS_GEN "${CMAKE_BINARY_DIR}/assets")
#set(ASSETS_INCLUDE "${ASSETS_GEN}/include")
#include_directories(${ASSETS_INCLUDE})

# gxtexconv - Textures
#include(gamecube.gxtexconv)
#set(GXTEXCONV_TARGET_NAME "assets_textures_gxtexconv")
#add_gxtexconv_target(${GXTEXCONV_TARGET_NAME} "${ASSETS_PATH}/textures" ${ASSETS_GEN} ${ASSETS_INCLUDE})

# bin2s - Binary Files
#include(gamecube.bin2s)
#set(BIN2O_TARGET_NAME "assets_textures_bin2o")
#add_bin2o_target(${BIN2O_TARGET_NAME} ${${GXTEXCONV_TARGET_NAME}_TPL} ${ASSETS_GEN} ${ASSETS_INCLUDE})

## PROJECT - CODE #
set(SOURCE_TARGET_NAME "source")

include(gamecube.macro)
add_subdirectory(source)

# elf2dol - .dol executable
include(gamecube.elf2dol)
add_dol_target(${PROJECT_NAME} ${SOURCE_TARGET_NAME} "TRUE" "source/${SOURCE_TARGET_NAME}")
