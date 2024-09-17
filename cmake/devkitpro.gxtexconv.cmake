# OUT: Defines add_gxtexconv_custom_target function for handling texture files accompanied by script files (.scf)

if(NOT GXTEXCONV_EXE)
    message(STATUS "Looking for gxtexconv")
    find_program(GXTEXCONV_EXE gxtexconv)
    if(GXTEXCONV_EXE)
        message(STATUS "    Found -- ${GXTEXCONV_EXE}")
    else()
        message(FATAL_ERROR "    Could not find gxtexconv")
    endif()
endif()

if(GXTEXCONV_EXE)
    define_property(
            TARGET
            PROPERTY GXTEXCONV_TPL_FILES
            BRIEF_DOCS "List of TPL files generated for a gxtexconv target"
    )

    # TODO: Support scf_files with arbitrary directory structure, generate in binary directory as parallel structure, and include all needed directories
    # TODO: additional_dependencies needs to be paired with their relevant scf_file, otherwise full generation has to occur on any dependency change
    # TODO: Update gxtexconv to generate DEPFILE based on scf's dependent filepaths instead of relying on provided additional_dependencies
    function(add_gxtexconv_interface target scf_files additional_dependencies)

        set(target_custom "${target}_custom_target")

        # Create target directories
        set(out_path "${CMAKE_CURRENT_BINARY_DIR}/gxtexconv")
        file(MAKE_DIRECTORY ${out_path})

        # Add a command to process each file with gxtexconv
        foreach(scf_file IN LISTS scf_files)

            get_filename_component(scf_filename ${scf_file} NAME) #TODO: Refactor to cmake_path

            # Compute output files
            string(REPLACE ".scf" ".h" out_file_h "${out_path}/${scf_filename}")
            string(REPLACE ".scf" ".tpl" out_file_tpl "${out_path}/${scf_filename}")

            # Append to files list
            list(APPEND out_files_h ${out_file_h})
            list(APPEND out_files_tpl ${out_file_tpl})

            # TEMP: Bypass bug in gxtexconv (fixed in extrems's fork)
            cmake_path(HAS_PARENT_PATH scf_file scf_file_has_parent_path)
            if(NOT ${scf_file_has_parent_path})
                cmake_path(SET scf_file_for_command "./${scf_file}")
            else()
                cmake_path(SET scf_file_for_command ${scf_file})
            endif()

            # Create gxtexconv command
            add_custom_command(
                    OUTPUT ${out_file_h} ${out_file_tpl}
                    DEPENDS ${scf_file} ${additional_dependencies}
                    COMMAND ${GXTEXCONV_EXE} ARGS -s ${scf_file_for_command} -o ${out_file_tpl}
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            )

        endforeach(scf_file)

        # Custom target for file generation
        add_custom_target(${target_custom}
                SOURCES ${scf_files}
                DEPENDS ${out_files_h} ${out_files_tpl}
        )

        # Interface target for include dependency
        add_library(${target} INTERFACE)
        target_include_directories(${target}
                INTERFACE ${out_path}
        )
        target_sources(${target}
                INTERFACE
                FILE_SET gxtexconv
                TYPE HEADERS
                FILES ${out_files_h}
        )
        set_target_properties(${target} PROPERTIES
                GXTEXCONV_TPL_FILES "${out_files_tpl}"
        )
        add_dependencies(${target} ${target_custom})

        # Log Target Interface
        message(STATUS ${target})
        get_target_property(include_dirs ${target} INTERFACE_INCLUDE_DIRECTORIES)
        message(STATUS "    Include Dirs: ${include_dirs}")
        get_target_property(hfiles ${target} HEADER_SET_gxtexconv)
        message(STATUS "    Headers: ${hfiles}")
        get_target_property(tplfiles ${target} GXTEXCONV_TPL_FILES)
        message(STATUS "    TPLs: ${tplfiles}")

    endfunction(add_gxtexconv_interface)
endif()
