cmake_minimum_required(VERSION 3.20.0)

# Enable new optimized variable evaluation
if(POLICY CMP0053)
    cmake_policy(SET CMP0053 NEW)
endif()

# Enable global GENERATED property
if(POLICY CMP0118)
    cmake_policy(SET CMP0118 NEW)
endif()

# Log active toolchain
message(STATUS "Using toolchain file: ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "Using C compiler: " ${CMAKE_C_COMPILER})
message(STATUS "Using C++ compiler: " ${CMAKE_CXX_COMPILER})

# PROJECT #
if(NOT DEFINED ENV{PROJECT})
    message(FATAL_ERROR "Please set PROJECT in your environment")
endif()
project("$ENV{PROJECT}" LANGUAGES CXX C ASM)

# Enable the next line to log target info
#set(CMAKE_MESSAGE_LOG_LEVEL VERBOSE)

# Enable the next line to see the actual commands run when building etc.
#set(CMAKE_VERBOSE_MAKEFILE ON)

# Enable the next line for debugging find commands
#set(CMAKE_FIND_DEBUG_MODE ON)

# Set the default search path for modules when using include / find_package
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Set to ON when target system is Wii
set(WII OFF)

# Set to ON when USBGekko is used (for using the db library which allow user to use their USBGekko as a GDBStub)
set(GEKKO OFF)

# TEMP HACK: Local project contains devkitpro config package instead of it being found in DEVKITPRO install location
set(devkitpro_ROOT "${CMAKE_SOURCE_DIR}/cmake/devkitpro")
find_package(devkitpro CONFIG REQUIRED)

# Global Compiler Flags
set(warning_flags "-Winline" "-Wall" "-Wextra")
set(cpp_flags "-fno-rtti" "-fno-exceptions")
set(debug_flags "-O0" "-g")
set(release_flags "-O3" "-fomit-frame-pointer" "-ffast-math")
add_compile_options(
        ${warning_flags}
        "$<$<COMPILE_LANGUAGE:CXX>:${cpp_flags}>"
        "$<$<CONFIG:Debug>:${debug_flags}>"
        "$<$<CONFIG:Release>:${release_flags}>"
)
add_link_options(
        ${warning_flags}
        "$<$<COMPILE_LANGUAGE:CXX>:${cpp_flags}>"
        "$<$<CONFIG:Debug>:${debug_flags}>"
        "$<$<CONFIG:Release>:${release_flags}>"
)

set(debug_definitions "DEBUG" "$<$<BOOL:${GEKKO}>:GEKKO>") # TODO: Determine if GEKKO should come from platform as it currently does (devkitpro-gamecube.cmake / devkitpro-wii.cmake)
add_compile_definitions(
        "$<$<CONFIG:Debug>:${debug_definitions}>"
)

# ASSETS #
set(scf_files
        textures/texture_test1/textures_1.scf
        textures/texture_test2/textures_2.scf
        textures/textures.scf
)
devkitpro_add_gxtexconv(assets_gxtexconv "${scf_files}" "assets" "")
get_target_property(gxtexconv_files assets_gxtexconv DEVKITPRO_GXTEXCONV_TPL_FILES)

# bin2s - Binary Files
devkitpro_add_bin2s(assets_bin2s "${gxtexconv_files}" "${CMAKE_CURRENT_BINARY_DIR}" "")
add_dependencies(assets_bin2s assets_gxtexconv)
target_link_libraries(assets_bin2s INTERFACE assets_gxtexconv)
target_link_libraries(assets_bin2s PRIVATE "devkitpro::$<IF:$<BOOL:${WII}>,wii,gamecube>")

# SOURCE #
add_executable(source_executable
        source/template.c
        source/gxsprites.c
)

target_link_libraries(source_executable
        PRIVATE "$<$<BOOL:${GEKKO}>:devkitpro::libogc::$<IF:$<BOOL:${WII}>,wii,gamecube>::db>" # db library must be linked first (see https://wiibrew.org/wiki/Debugging)
        PRIVATE "devkitpro::$<IF:$<BOOL:${WII}>,wii,gamecube>"
        PRIVATE "devkitpro::libogc::$<IF:$<BOOL:${WII}>,wii,gamecube>::ogc"
)
target_link_libraries(source_executable PUBLIC assets_bin2s)

# elf2dol - .dol executable
devkitpro_add_elf2dol("${PROJECT_NAME}_dol" "${PROJECT_NAME}.dol" $<TARGET_FILE:source_executable> TRUE)
