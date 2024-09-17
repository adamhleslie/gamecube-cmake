# Set up a GameCube executable target
# Add the definition for the libogc headers
function(setup_gamecube_executable target libogc_libs)

    target_link_libogc(${target} "${libogc_libs}" "cube")
    setup_gamecube_flags(${target})

endfunction(setup_gamecube_executable)

# Set up a Wii executable target
# Add the definition for the libogc headers
function(setup_wii_executable target libogc_libs)

    target_link_libogc(${target} "${libogc_libs}" "wii")
    setup_wii_flags(${target})

endfunction(setup_wii_executable)

function(setup_gamecube_flags target)

    set(arch_flags "-DGEKKO -mogc -mcpu=750 -meabi -mhard-float")
    set_target_properties(${target} PROPERTIES # TODO: Replace with modern cmake's target_link_options / target_compile_options (PRIVATE)
            LINK_FLAGS "${arch_flags}"
            COMPILE_FLAGS "${arch_flags}"
    )

endfunction(setup_gamecube_flags)

function(setup_wii_flags target)

    set(arch_flags "-DGEKKO -mrvl -mcpu=750 -meabi -mhard-float")
    set_target_properties(${target} PROPERTIES # TODO: Replace with modern cmake's target_link_options / target_compile_options (PRIVATE)
            LINK_FLAGS "${arch_flags}"
            COMPILE_FLAGS "${arch_flags}"
    )

endfunction(setup_wii_flags)

# TODO: Remove linking here, and just do lookup/setup instead here or in toolchain?
# Used to link to imported libogc libraries
function(target_link_libogc target libogc_libs path_suffix)

    # Uncomment the following line for debugging find_library
    #set(CMAKE_FIND_DEBUG_MODE 1)

    # Link all libogc libraries
    set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    foreach(libogc_lib ${libogc_libs})
        if(NOT DEFINED "LIBOGC_${libogc_lib}")
            message(STATUS "Looking for libogc's ${libogc_lib}")
            find_library("LIBOGC_${libogc_lib}_IMPORT" ${libogc_lib}
                    NO_PACKAGE_ROOT_PATH
                    PATHS "${DEVKITPRO}/libogc"
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


