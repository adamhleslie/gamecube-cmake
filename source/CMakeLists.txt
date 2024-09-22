add_executable(source_executable
        template.c
        gxsprites.c
)

set(source_libogc_libs
        ogc
)

if(${WII})
    message(STATUS "Setting up Wii target...")
    target_link_libogc(source_executable "${source_libogc_libs}" "wii")
    target_link_libraries(source_executable PRIVATE devkitpro::wii)
else()
    message(STATUS "Setting up Gamecube target...")
    target_link_libogc(source_executable "${source_libogc_libs}" "cube")
    target_link_libraries(source_executable PRIVATE devkitpro::gamecube)
endif()
