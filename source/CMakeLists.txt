add_executable(gamecube_executable
        template.c
        gxsprites.c
)

set(source_libogc_libs
        ogc
)

include(devkitpro.gamecube)
if(${WII})
    message("Setting up Wii target...")
    setup_wii_executable(gamecube_executable "${source_libogc_libs}")
else()
    message("Setting up Gamecube target...")
    setup_gamecube_executable(gamecube_executable "${source_libogc_libs}")
endif()
