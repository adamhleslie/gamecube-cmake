cmake_minimum_required(VERSION 3.20.0)

include("${CMAKE_CURRENT_LIST_DIR}/devkitpro-helpers.cmake")

# Set up devkitPro variable
if(DEFINED DEVKITPRO)
    devkitpro_message(STATUS "Using existing DEVKITPRO value: ${DEVKITPRO}")
else()
    if(DEFINED ENV{DEVKITPRO})
        set(DEVKITPRO $ENV{DEVKITPRO})
        devkitpro_message(STATUS "Setting DEVKITPRO from environment: ${DEVKITPRO}")
    elseif(EXISTS "/opt/devkitpro")
        set(DEVKITPRO "/opt/devkitpro")
        devkitpro_message(STATUS "Setting DEVKITPRO to default location: ${DEVKITPRO}")
    else()
        devkitpro_message(FATAL_ERROR "DEVKITPRO not valid: Default location \"/opt/devkitpro\" does not exist, and DEVKITPRO not set in environment")
    endif()
endif()

# Find all files to include
file(GLOB include_files LIST_DIRECTORIES false
        "${CMAKE_CURRENT_LIST_DIR}/platforms/*.cmake"
        "${CMAKE_CURRENT_LIST_DIR}/libraries/*.cmake"
        "${CMAKE_CURRENT_LIST_DIR}/tools/*.cmake"
)

foreach(include_file IN LISTS include_files)
    include(${include_file})
endforeach()
