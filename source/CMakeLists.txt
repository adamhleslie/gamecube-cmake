add_executable(source_executable
        template.c
        gxsprites.c
)

target_link_libraries(source_executable
        PRIVATE "devkitpro::$<IF:$<BOOL:${WII}>,wii,gamecube>"
        PRIVATE "devkitpro::libogc::$<IF:$<BOOL:${WII}>,wii,gamecube>::ogc"
        PRIVATE "$<$<BOOL:${GEKKO}>:devkitpro::libogc::$<IF:$<BOOL:${WII}>,wii,gamecube>::db>"
)