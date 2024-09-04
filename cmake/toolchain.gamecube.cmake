# Target platform to build for an embedded system without an OS
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)

# Target architecture to build for
set(CMAKE_SYSTEM_PROCESSOR ppc)

# Get devkitPro from the environment
if(NOT DEFINED ENV{DEVKITPRO})
    message(FATAL_ERROR "Please set DEVKITPRO in your environment")
endif()
set(DEVKITPRO $ENV{DEVKITPRO})

# Add search directories for find_program, find_library, find_package, find_file, and find_path calls
set(CMAKE_FIND_ROOT_PATH
        ${DEVKITPRO}/devkitPPC
        ${DEVKITPRO}/devkitPPC/powerpc-eabi-
        ${DEVKITPRO}/tools
        ${DEVKITPRO}/libogc
)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)

# Add libogc includes
include_directories(${DEVKITPRO}/libogc/include)

# Find core compilation programs
set(prefix powerpc-eabi-)
find_program(CMAKE_ASM_COMPILER   ${prefix}gcc        REQUIRED)
find_program(CMAKE_C_COMPILER     ${prefix}gcc        REQUIRED)
find_program(CMAKE_CXX_COMPILER   ${prefix}g++        REQUIRED)
find_program(CMAKE_OBJCOPY        ${prefix}objcopy    REQUIRED)
find_program(CMAKE_OBJDUMP        ${prefix}objdump    REQUIRED)
find_program(CMAKE_LINKER         ${prefix}ld         REQUIRED)
find_program(CMAKE_AR             ${prefix}ar         REQUIRED)
find_program(CMAKE_RANLIB         ${prefix}ranlib     REQUIRED)
find_program(CMAKE_STRIP          ${prefix}strip      REQUIRED)

# Disable building shared libs
SET(BUILD_SHARED_LIBS OFF CACHE INTERNAL "Shared libs not available" )