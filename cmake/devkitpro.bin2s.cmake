# OUT: Defines add_bin2s_library function for converting binary files to object files

if(NOT BIN2S_EXE)
    message(STATUS "Looking for bin2s")
    find_program(BIN2S_EXE bin2s)
    if(BIN2S_EXE)
        message(STATUS "    Found -- ${BIN2S_EXE}")
    else()
        message(FATAL_ERROR "    Could not find bin2s")
    endif()
endif()

if(BIN2S_EXE)

    # TODO: Support binary_files with arbitrary directory structure, generate in binary directory as parallel structure, and include all needed directories
    function(add_bin2s_library target binary_files)

        # Create target directories
        set(out_path "${CMAKE_CURRENT_BINARY_DIR}/bin2s")
        file(MAKE_DIRECTORY ${out_path})

        # Add a command to process each file with bin2s
        foreach(binary_file IN LISTS binary_files)

            # Compute output files
            cmake_path(GET binary_file STEM binary_file_stem)
            cmake_path(GET binary_file EXTENSION binary_file_extension)
            string(REPLACE "." "_" object_suffix ${binary_file_extension})
            set(out_file_h "${out_path}/${binary_file_stem}${object_suffix}.h")
            set(out_file_s "${out_path}/${binary_file_stem}${object_suffix}.s")

            # Append to files list
            list(APPEND out_files_h ${out_file_h})
            list(APPEND out_files_s ${out_file_s})

            # Create bin2s command
            add_custom_command(
                    OUTPUT ${out_file_h} ${out_file_s}
                    DEPENDS ${binary_file}
                    COMMAND ${BIN2S_EXE} ARGS -a 32 -H ${out_file_h} ${binary_file} > ${out_file_s}
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
        message(STATUS ${target})
        get_target_property(include_dirs ${target} INTERFACE_INCLUDE_DIRECTORIES)
        message(STATUS "    Include Dirs: ${include_dirs}")
        get_target_property(hfiles ${target} HEADER_SET_bin2s)
        message(STATUS "    Headers: ${hfiles}")
        get_target_property(sfiles ${target} SOURCES)
        message(STATUS "    Sources: ${sfiles}")

    endfunction(add_bin2s_library)
endif()
