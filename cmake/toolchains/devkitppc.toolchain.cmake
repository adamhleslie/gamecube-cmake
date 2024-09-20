# Target platform to build for an embedded system without an OS
set(CMAKE_SYSTEM_NAME "Generic")
set(CMAKE_SYSTEM_VERSION 1)

# Target architecture to build for
set(CMAKE_SYSTEM_PROCESSOR "ppc")

# Set up devkitPro variable
if(NOT DEFINED DEVKITPRO)
    if(DEFINED ENV{DEVKITPRO})
        set(DEVKITPRO $ENV{DEVKITPRO})
        message(STATUS "Setting DEVKITPRO from environment: ${DEVKITPRO}")
    elseif(EXISTS "/opt/devkitpro")
        set(DEVKITPRO "/opt/devkitpro")
        message(STATUS "Setting DEVKITPRO to default location: ${DEVKITPRO}")
    else()
        message(FATAL_ERROR "DEVKITPRO not valid: Default location \"/opt/devkitpro\" does not exist, and DEVKITPRO not set in environment")
    endif()
endif()

list(APPEND CMAKE_FIND_ROOT_PATH
        "${DEVKITPRO}/devkitPPC"
)

# Find core compilation programs
set(prefix "powerpc-eabi-")
find_program(CMAKE_ASM_COMPILER "${prefix}gcc"      REQUIRED)
find_program(CMAKE_C_COMPILER   "${prefix}gcc"      REQUIRED)
find_program(CMAKE_CXX_COMPILER "${prefix}g++"      REQUIRED)
find_program(CMAKE_OBJCOPY      "${prefix}objcopy"  REQUIRED)
find_program(CMAKE_OBJDUMP      "${prefix}objdump"  REQUIRED)
find_program(CMAKE_LINKER       "${prefix}ld"       REQUIRED)
find_program(CMAKE_AR           "${prefix}ar"       REQUIRED)
find_program(CMAKE_RANLIB       "${prefix}ranlib"   REQUIRED)
find_program(CMAKE_STRIP        "${prefix}strip"    REQUIRED)