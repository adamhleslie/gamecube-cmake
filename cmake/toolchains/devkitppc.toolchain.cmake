# shared toolchain file
include("${CMAKE_CURRENT_LIST_DIR}/shared.toolchain.cmake")

# Target platform and architecture
set(CMAKE_SYSTEM_NAME "Generic") # embedded system without an OS
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR "ppc")

# Add find_... function paths for cross-compilation
list(APPEND CMAKE_SYSTEM_PREFIX_PATH
        "${DEVKITPRO}/devkitPPC"
        "${DEVKITPRO}/devkitPPC/powerpc-eabi"
        "${DEVKITPRO}/portlibs/ppc"
        "${DEVKITPRO}/tools"
)

# Find core compilation programs based on architecture triplet
set(triplet "powerpc-eabi")
set(hint "${DEVKITPRO}/devkitPPC/bin")
find_program(CMAKE_ASM_COMPILER "${triplet}-gcc"      HINTS "${hint}" REQUIRED)
find_program(CMAKE_C_COMPILER   "${triplet}-gcc"      HINTS "${hint}" REQUIRED)
find_program(CMAKE_CXX_COMPILER "${triplet}-g++"      HINTS "${hint}" REQUIRED)
find_program(CMAKE_LINKER       "${triplet}-ld"       HINTS "${hint}" REQUIRED)
find_program(CMAKE_AR           "${triplet}-ar"       HINTS "${hint}" REQUIRED)
find_program(CMAKE_RANLIB       "${triplet}-ranlib"   HINTS "${hint}" REQUIRED)
find_program(CMAKE_STRIP        "${triplet}-strip"    HINTS "${hint}" REQUIRED)
find_program(CMAKE_OBJCOPY      "${triplet}-objcopy"  HINTS "${hint}" REQUIRED)
find_program(CMAKE_OBJDUMP      "${triplet}-objdump"  HINTS "${hint}" REQUIRED)
find_program(CMAKE_NM           "${triplet}-nm"       HINTS "${hint}" REQUIRED)