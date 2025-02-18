# devkitPPC toolchain file
include("${CMAKE_CURRENT_LIST_DIR}/devkitppc.toolchain.cmake")

# Override devkitPPC's system name
set(CMAKE_SYSTEM_NAME "NintendoGameCube")

# Add GameCube specific find_... function paths
list(APPEND CMAKE_SYSTEM_PREFIX_PATH
        "${DEVKITPRO}/portlibs/gamecube"
)

# Find pkg-config specific to GameCube
find_program(PKG_CONFIG_EXECUTABLE "powerpc-eabi-pkg-config" HINTS "${DEVKITPRO}/portlibs/gamecube/bin" REQUIRED)

# TODO: Is there a better way to do this?
# Set bin2s alignment for use with devkitpro_add_bin2s function
set(DEVKITPRO_BIN2S_ALIGNMENT 32)