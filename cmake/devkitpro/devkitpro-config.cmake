cmake_minimum_required(VERSION 3.20.0)

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

# Platform specific targets
include("${CMAKE_CURRENT_LIST_DIR}/devkitpro-gamecube.cmake")

# Programs
include("${CMAKE_CURRENT_LIST_DIR}/devkitpro-bin2s.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/devkitpro-elf2dol.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/devkitpro-gxtexconv.cmake")
