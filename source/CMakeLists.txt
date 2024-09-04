if(NOT SOURCE_TARGET_NAME)
    message(FATAL_ERROR "Please set SOURCE_TARGET_NAME")
endif()

add_executable(${SOURCE_TARGET_NAME}
        template.c)

set(source_libogc_libs
        ogc)

setup_gamecube_target("${SOURCE_TARGET_NAME}" "${source_libogc_libs}")
