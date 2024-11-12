add_executable(source_executable
        template.c
        gxsprites.c
)

if(${WII})
    message(STATUS "Setting up Wii target...")
    if(GEKKO)
        target_link_libraries(source_executable
                PRIVATE devkitpro::wii
                PRIVATE devkitpro::libogc::wii::db
                PRIVATE devkitpro::libogc::wii::ogc
        )
    else()
        target_link_libraries(source_executable
                PRIVATE devkitpro::wii
                PRIVATE devkitpro::libogc::wii::ogc
        )
    endif()
else()
    message(STATUS "Setting up Gamecube target...")
    if(GEKKO)
        target_link_libraries(source_executable
                PRIVATE devkitpro::gamecube
                PRIVATE devkitpro::libogc::gamecube::db
                PRIVATE devkitpro::libogc::gamecube::ogc
        )
    else()
        target_link_libraries(source_executable
                PRIVATE devkitpro::gamecube
                PRIVATE devkitpro::libogc::gamecube::ogc
        )
    endif()
endif()