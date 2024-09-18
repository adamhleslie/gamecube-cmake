# Target platform to build for an embedded system without an OS
set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_SYSTEM_VERSION 1)

# Target architecture to build for
set(CMAKE_SYSTEM_PROCESSOR "ppc")

# Get devkitPro from the environment
if(NOT DEFINED ENV{DEVKITPRO})
    message(FATAL_ERROR "Please set DEVKITPRO in your environment")
endif()
set(DEVKITPRO $ENV{DEVKITPRO})

# Find core compilation programs
set(paths "${DEVKITPRO}/devkitPPC/bin")
set(prefix "powerpc-eabi-")
find_program(CMAKE_ASM_COMPILER "${prefix}gcc"      PATHS ${paths} NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_C_COMPILER   "${prefix}gcc"      PATHS ${paths} NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_CXX_COMPILER "${prefix}g++"      PATHS ${paths} NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_OBJCOPY      "${prefix}objcopy"  PATHS ${paths} NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_OBJDUMP      "${prefix}objdump"  PATHS ${paths} NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_LINKER       "${prefix}ld"       PATHS ${paths} NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_AR           "${prefix}ar"       PATHS ${paths} NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_RANLIB       "${prefix}ranlib"   PATHS ${paths} NO_DEFAULT_PATH REQUIRED)
find_program(CMAKE_STRIP        "${prefix}strip"    PATHS ${paths} NO_DEFAULT_PATH REQUIRED)