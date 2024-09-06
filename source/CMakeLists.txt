if(NOT SOURCE_TARGET_NAME)
    message(FATAL_ERROR "Please set SOURCE_TARGET_NAME")
endif()

add_executable(${SOURCE_TARGET_NAME}
        template.c)

set(source_libogc_libs
        ogc)


if(${WII_TARGET})
    message("Setting up WII target...")
    setup_wii_target("${SOURCE_TARGET_NAME}" "${source_libogc_libs}")
else ()
    message("Setting up Gamecube target...")
    setup_gamecube_target("${SOURCE_TARGET_NAME}" "${source_libogc_libs}")
endif ()