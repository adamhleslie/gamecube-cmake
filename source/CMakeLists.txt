add_executable(source_executable
        template.c
        gxsprites.c
)

set(source_libogc_libs
        ogc
)

include(devkitpro.gamecube)
if(${WII})
    message(STATUS "Setting up Wii target...")
    setup_wii_executable(source_executable "${source_libogc_libs}")
else()
    message(STATUS "Setting up Gamecube target...")
    setup_gamecube_executable(source_executable "${source_libogc_libs}")
endif()
