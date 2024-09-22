include_guard(GLOBAL)
# OUT: add_bin2s_library function for converting binary files to object files

devkitpro_find_file(DEVKITPRO_BIN2S "tools/bin/bin2s")

if(DEVKITPRO_BIN2S)
    function(add_bin2s_library target binary_files)

        # Create target directories
        cmake_path(APPEND out_path ${CMAKE_CURRENT_BINARY_DIR} "bin2s")
        file(MAKE_DIRECTORY ${out_path})

        # Add a command to process each file with bin2s
        foreach(binary_file IN LISTS binary_files)

            # Compute output files
            cmake_path(GET binary_file STEM binary_file_stem)
            cmake_path(GET binary_file EXTENSION binary_file_extension)
            string(REPLACE "." "_" out_file_suffix ${binary_file_extension})
            cmake_path(APPEND out_file_base ${out_path} ${binary_file_stem})
            cmake_path(APPEND_STRING out_file_base ${out_file_suffix})
            cmake_path(REPLACE_EXTENSION out_file_base ".h" OUTPUT_VARIABLE out_file_h)
            cmake_path(REPLACE_EXTENSION out_file_base ".s" OUTPUT_VARIABLE out_file_s)

            # Append to files list
            list(APPEND out_files_h ${out_file_h})
            list(APPEND out_files_s ${out_file_s})

            # Create bin2s command
            add_custom_command(
                    OUTPUT ${out_file_h} ${out_file_s}
                    DEPENDS ${binary_file}
                    COMMAND ${DEVKITPRO_BIN2S} ARGS -a 32 -H ${out_file_h} ${binary_file} > ${out_file_s}
            )

        endforeach(binary_file)

        add_library(${target} OBJECT ${out_files_s})
        target_include_directories(${target}
                INTERFACE ${out_path}
        )
        target_sources(${target}
                INTERFACE
                FILE_SET bin2s
                TYPE HEADERS
                BASE_DIRS ${out_path}
                FILES ${out_files_h}
        )

        # Log Target Info
        devkitpro_message(VERBOSE ${target})
        get_target_property(include_dirs ${target} INTERFACE_INCLUDE_DIRECTORIES)
        devkitpro_message(VERBOSE "    Include Dirs: ${include_dirs}")
        get_target_property(hfiles ${target} HEADER_SET_bin2s)
        devkitpro_message(VERBOSE "    Headers: ${hfiles}")
        get_target_property(sfiles ${target} SOURCES)
        devkitpro_message(VERBOSE "    Sources: ${sfiles}")

    endfunction(add_bin2s_library)
endif()
