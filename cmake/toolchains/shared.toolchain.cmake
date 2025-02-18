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

# Suppress "System is unknown to cmake" warning via "./modules/platform/..." files
list(APPEND CMAKE_MODULE_PATH
        "${CMAKE_CURRENT_LIST_DIR}/modules"
)