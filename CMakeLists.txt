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

# Set the default search path for modules when using include / find_package
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Set to ON when target system is Wii
set(WII OFF)

# Compiler Flags
set(warning_flags "-Winline" "-Wall" "-Wextra")
set(cpp_flags "-fno-rtti" "-fno-exceptions")
set(debug_flags "-O0" "-g" "-DDEBUG")
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

# Defines assets_bin2s_library
add_subdirectory(assets)

# Defines source_executable
add_subdirectory(source)
target_link_libraries(source_executable PUBLIC assets_bin2s_library)

# elf2dol - .dol executable
include(devkitpro.elf2dol)
add_dol_custom("${PROJECT_NAME}_dol" "${PROJECT_NAME}.dol" $<TARGET_FILE:source_executable>)
