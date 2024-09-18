include_guard(GLOBAL)
# OUT: gamecube_interface / wii_interface libraries providing compile and link options via interface
# OUT: target_link_libogc function for linking to imported libogc libraries

block(SCOPE_FOR VARIABLES)
    add_library(gamecube_interface INTERFACE)
    set(arch_flags "-mogc" "-mcpu=750" "-meabi" "-mhard-float")
    set(definitions "GEKKO")
    target_compile_options(gamecube_interface
            INTERFACE ${arch_flags}
    )
    target_link_options(gamecube_interface
            INTERFACE ${arch_flags}
    )
    target_compile_definitions(gamecube_interface
            INTERFACE ${definitions}
    )
endblock()

block(SCOPE_FOR VARIABLES)
    add_library(wii_interface INTERFACE)
    set(arch_flags "-mrvl" "-mcpu=750" "-meabi" "-mhard-float")
    set(definitions "GEKKO")
    target_compile_options(wii_interface
            INTERFACE ${arch_flags}
    )
    target_link_options(wii_interface
            INTERFACE ${arch_flags}
    )
    target_compile_definitions(wii_interface
            INTERFACE ${definitions}
    )
endblock()

# TODO: Remove linking here, and just do lookup/setup instead here or in toolchain?
# Used to link to imported libogc libraries
function(target_link_libogc target libogc_libs path_suffix)

    # Uncomment the following line for debugging find_library
    #set(CMAKE_FIND_DEBUG_MODE ON)

    # Link all libogc libraries
    set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    foreach(libogc_lib ${libogc_libs})
        if(NOT DEFINED "LIBOGC_${libogc_lib}")
            message(STATUS "Looking for libogc's ${libogc_lib}")
            find_library("LIBOGC_${libogc_lib}_IMPORT" ${libogc_lib}
                    NO_DEFAULT_PATH
                    PATHS "${DEVKITPRO}/libogc/lib"
                    PATH_SUFFIXES ${path_suffix}
            )
            if(LIBOGC_${libogc_lib}_IMPORT)
                add_library("LIBOGC_${libogc_lib}" INTERFACE)
                target_link_libraries("LIBOGC_${libogc_lib}" INTERFACE ${LIBOGC_${libogc_lib}_IMPORT})
                target_include_directories("LIBOGC_${libogc_lib}" INTERFACE "${DEVKITPRO}/libogc/include")
                message(STATUS "    Found -- ${LIBOGC_${libogc_lib}_IMPORT}")
            else()
                message(FATAL_ERROR "    Could not find ${libogc_lib}")
            endif()
        endif()

        target_link_libraries(${target} PUBLIC "LIBOGC_${libogc_lib}")
    endforeach(libogc_lib)

endfunction(target_link_libogc)


