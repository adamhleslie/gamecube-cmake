include_guard(GLOBAL)
# OUT: target_link_libogc function for linking to imported libogc libraries

# TODO: Remove linking here, and just do lookup/setup instead here or in toolchain?
# Used to link to imported libogc libraries
function(target_link_libogc target libogc_libs path_suffix)

    # Link all libogc libraries
    set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    foreach(libogc_lib ${libogc_libs})
        if(NOT DEFINED "LIBOGC_${libogc_lib}")
            devkitpro_message(STATUS "Looking for libogc's ${libogc_lib}")
            find_library("LIBOGC_${libogc_lib}_IMPORT" ${libogc_lib}
                    NO_DEFAULT_PATH
                    PATHS "${DEVKITPRO}/libogc/lib"
                    PATH_SUFFIXES ${path_suffix}
            )
            if(LIBOGC_${libogc_lib}_IMPORT)
                add_library("LIBOGC_${libogc_lib}" INTERFACE)
                target_link_libraries("LIBOGC_${libogc_lib}" INTERFACE ${LIBOGC_${libogc_lib}_IMPORT})
                target_include_directories("LIBOGC_${libogc_lib}" INTERFACE "${DEVKITPRO}/libogc/include")
                devkitpro_message(STATUS "    Found -- ${LIBOGC_${libogc_lib}_IMPORT}")
            else()
                devkitpro_message(FATAL_ERROR "    Could not find ${libogc_lib}")
            endif()
        endif()

        target_link_libraries(${target} PUBLIC "LIBOGC_${libogc_lib}")
    endforeach(libogc_lib)

endfunction(target_link_libogc)