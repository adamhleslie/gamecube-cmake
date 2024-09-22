add_executable(source_executable
        template.c
        gxsprites.c
)

if(${WII})
    message(STATUS "Setting up Wii target...")
    target_link_libraries(source_executable
            PRIVATE devkitpro::wii
            PRIVATE devkitpro::libogc::wii::ogc
    )
else()
    message(STATUS "Setting up Gamecube target...")
    target_link_libraries(source_executable
            PRIVATE devkitpro::gamecube
            PRIVATE devkitpro::libogc::gamecube::ogc
    )
endif()
