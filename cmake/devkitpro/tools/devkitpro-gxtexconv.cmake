include_guard(GLOBAL)
# OUT: devkitpro_add_gxtexconv function adds a interface library for converting .scf files and their associated textures into .tpl files
#   - DEVKITPRO_GXTEXCONV_TPL_FILES property on target set to the list of generated .tpl files

devkitpro_find_file(DEVKITPRO_GXTEXCONV "tools/bin/gxtexconv")

if(DEVKITPRO_GXTEXCONV)
    define_property(
            TARGET
            PROPERTY DEVKITPRO_GXTEXCONV_TPL_FILES
            BRIEF_DOCS "List of TPL files generated for a gxtexconv target"
    )

    function(devkitpro_add_gxtexconv target scf_files)

        set(target_custom "${target}_custom")

        # Create target directories
        cmake_path(APPEND out_path ${CMAKE_CURRENT_BINARY_DIR} "gxtexconv")
        file(MAKE_DIRECTORY ${out_path})

        # Add a command to process each file with gxtexconv
        foreach(scf_file IN LISTS scf_files)

            # Compute output files
            cmake_path(ABSOLUTE_PATH scf_file)
            cmake_path(RELATIVE_PATH scf_file BASE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
            cmake_path(GET scf_file FILENAME scf_file_name)
            cmake_path(APPEND out_file_base ${out_path} ${scf_file_name})
            cmake_path(REPLACE_EXTENSION out_file_base ".h" OUTPUT_VARIABLE out_file_h)
            cmake_path(REPLACE_EXTENSION out_file_base ".tpl" OUTPUT_VARIABLE out_file_tpl)
            cmake_path(REPLACE_EXTENSION out_file_base ".d" OUTPUT_VARIABLE out_file_dep)

            # Append to files list
            list(APPEND out_files_h ${out_file_h})
            list(APPEND out_files_tpl ${out_file_tpl})

            # TEMP: Bypass bug in gxtexconv by making sure there is at least one forward slash (fixed in extrems's gxtexconv fork)
            cmake_path(HAS_PARENT_PATH scf_file scf_file_has_parent_path)
            if(NOT ${scf_file_has_parent_path})
                cmake_path(SET scf_file_for_command "./${scf_file}")
            else()
                cmake_path(SET scf_file_for_command ${scf_file})
            endif()

            # Create gxtexconv command
            add_custom_command(
                    OUTPUT ${out_file_h} ${out_file_tpl} ${out_file_dep}
                    DEPENDS ${out_file_tpl} # Self-dependency to cause re-checking of DEPFILE for command
                    DEPFILE ${out_file_dep}
                    COMMAND ${DEVKITPRO_GXTEXCONV} ARGS -s ${scf_file_for_command} -o ${out_file_tpl} -d ${out_file_dep}
            )

        endforeach(scf_file)

        # Custom target for file generation
        add_custom_target(${target_custom}
                DEPENDS ${out_files_h} ${out_files_tpl} ${out_file_dep}
                SOURCES ${scf_files}
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
                BASE_DIRS ${out_path}
                FILES ${out_files_h}
        )
        set_target_properties(${target} PROPERTIES
                DEVKITPRO_GXTEXCONV_TPL_FILES "${out_files_tpl}"
        )
        add_dependencies(${target} ${target_custom})

        # Log Target Info
        devkitpro_message(VERBOSE ${target})
        get_target_property(include_dirs ${target} INTERFACE_INCLUDE_DIRECTORIES)
        devkitpro_message(VERBOSE "    Include Dirs: ${include_dirs}")
        get_target_property(hfiles ${target} HEADER_SET_gxtexconv)
        devkitpro_message(VERBOSE "    Headers: ${hfiles}")
        get_target_property(tplfiles ${target} DEVKITPRO_GXTEXCONV_TPL_FILES)
        devkitpro_message(VERBOSE "    TPLs: ${tplfiles}")

    endfunction(devkitpro_add_gxtexconv)
endif()
