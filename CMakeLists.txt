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

# PROJECT #
if(NOT DEFINED ENV{PROJECT})
    message(FATAL_ERROR "Please set PROJECT in your environment")
endif()
project("$ENV{PROJECT}" LANGUAGES CXX C ASM)

# Debugging variables:
#set(CMAKE_MESSAGE_LOG_LEVEL VERBOSE) # Log target info
#set(CMAKE_VERBOSE_MAKEFILE ON) # Log actual commands run when building
#set(CMAKE_FIND_DEBUG_MODE ON) # Log debugging info for find commands

# Set the default search path for modules when using include / find_package
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Set to ON when target system is Wii - CMAKE_SYSTEM_NAME is set by toolchain files
if("${CMAKE_SYSTEM_NAME}" STREQUAL "NintendoWii")
    set(WII ON)
else()
    set(WII OFF)
endif()

# Set to ON when USBGekko is used (for using the db library which allow user to use their USBGekko as a GDBStub)
set(GEKKO OFF)

# Local project contains devkitpro config package
set(devkitpro_ROOT "${CMAKE_SOURCE_DIR}/cmake/devkitpro")
find_package(devkitpro CONFIG REQUIRED)

# Global Compiler Flags
set(warning_flags "-Winline" "-Wall" "-Wextra")
set(cpp_flags "-fno-rtti" "-fno-exceptions")
set(debug_flags "-g" "-O0")
set(minSizeRel_flags "-g" "-Oz")
set(release_flags "-O3" "-fomit-frame-pointer" "-ffast-math")
set(releaseWithDebInfo_flags "-g" ${release_flags})
add_compile_options(
        ${warning_flags}
        "$<$<COMPILE_LANGUAGE:CXX>:${cpp_flags}>"
        "$<$<CONFIG:Debug>:${debug_flags}>"
        "$<$<CONFIG:MinSizeRel>:${minSizeRel_flags}>"
        "$<$<CONFIG:Release>:${release_flags}>"
        "$<$<CONFIG:RelWithDebInfo>:${releaseWithDebInfo_flags}>"
)
add_link_options(
        ${warning_flags}
        "$<$<COMPILE_LANGUAGE:CXX>:${cpp_flags}>"
        "$<$<CONFIG:Debug>:${debug_flags}>"
        "$<$<CONFIG:MinSizeRel>:${minSizeRel_flags}>"
        "$<$<CONFIG:Release>:${release_flags}>"
        "$<$<CONFIG:RelWithDebInfo>:${releaseWithDebInfo_flags}>"
)

set(debug_definitions "DEBUG" "$<$<BOOL:${GEKKO}>:GEKKO>") # TODO: Determine if GEKKO should come from platform as it currently does (dkp-gamecube.cmake / dkp-wii.cmake)
add_compile_definitions(
        "$<$<CONFIG:Debug>:${debug_definitions}>"
)

# ASSETS #
set(scf_files
        textures/texture_test1/textures_1.scf
        textures/texture_test2/textures_2.scf
        textures/textures.scf
)
dkp_add_gxtexconv(assets_gxtexconv "${scf_files}" "assets" "")
get_target_property(gxtexconv_files assets_gxtexconv DKP_GXTEXCONV_TPL_FILES)

# bin2s - Binary Files
dkp_add_bin2s(assets_bin2s "${gxtexconv_files}" "${CMAKE_CURRENT_BINARY_DIR}" "")
add_dependencies(assets_bin2s assets_gxtexconv)
target_link_libraries(assets_bin2s INTERFACE assets_gxtexconv)
target_link_libraries(assets_bin2s PRIVATE "dkp::$<IF:$<BOOL:${WII}>,wii,gamecube>")

# SOURCE #
add_executable(source_executable
        source/template.c
        source/gxsprites.c
)

target_link_libraries(source_executable
        PRIVATE "$<$<BOOL:${GEKKO}>:dkp::libogc::$<IF:$<BOOL:${WII}>,wii,gamecube>::db>" # db library must be linked first (see https://wiibrew.org/wiki/Debugging)
        PRIVATE "dkp::$<IF:$<BOOL:${WII}>,wii,gamecube>"
        PRIVATE "dkp::libogc::$<IF:$<BOOL:${WII}>,wii,gamecube>::ogc"
)
target_link_libraries(source_executable PUBLIC assets_bin2s)

# elf2dol - .dol executable
dkp_add_elf2dol("${PROJECT_NAME}_dol" "${PROJECT_NAME}.dol" $<TARGET_FILE:source_executable> TRUE)
