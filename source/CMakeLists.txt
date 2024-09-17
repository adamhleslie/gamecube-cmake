add_executable(gamecube_executable
        template.c
        gxsprites.c
)

set(source_libogc_libs
        ogc
)

include(devkitpro.gamecube)
setup_gamecube_executable(gamecube_executable "${source_libogc_libs}")
