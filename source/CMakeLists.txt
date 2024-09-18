add_executable(source_executable
        template.c
        gxsprites.c
)

set(source_libogc_libs
        ogc
)

include(devkitpro-gamecube)
if(${WII})
    message(STATUS "Setting up Wii target...")
    target_link_libogc(source_executable "${source_libogc_libs}" "wii")
    target_link_libraries(source_executable PRIVATE wii_interface)
else()
    message(STATUS "Setting up Gamecube target...")
    target_link_libogc(source_executable "${source_libogc_libs}" "cube")
    target_link_libraries(source_executable PRIVATE gamecube_interface)
endif()
