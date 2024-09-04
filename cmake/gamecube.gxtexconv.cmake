# OUT: Defines add_gxtexconv_target function for handling texture files accompanied by script files (.scf)
#   - Sets variables ${target_name}_TPL and ${target_name}_H in parent scope for referencing custom target outputs

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
    function(add_gxtexconv_target target_name src_path gen_path include_path)

        # Find all .scf files
        file(GLOB scf_files "${src_path}/*.scf")

        # Create target directories
        file(MAKE_DIRECTORY ${gen_path})
        file(MAKE_DIRECTORY ${include_path})

        # Add a command to process each file with gxtexconv
        foreach(scf_file ${scf_files})
            get_filename_component(scf_filename ${scf_file} NAME)

            # Compute output files
            string(REPLACE ".scf" ".h" gen_file_h "${gen_path}/${scf_filename}")
            string(REPLACE ".scf" ".tpl" gen_file_tpl "${gen_path}/${scf_filename}")
            string(REPLACE ".scf" ".h" include_file_h "${include_path}/${scf_filename}")

            # Mark as generated files
            set_source_files_properties("${gen_file_tpl}" PROPERTIES GENERATED TRUE)
            set_source_files_properties("${include_file_h}" PROPERTIES GENERATED TRUE)

            # Append to files list
            set(gen_files_tpl ${gen_files_tpl} ${gen_file_tpl})
            set(include_files_h ${include_files_h} ${include_file_h})

            # Create gxtexconv command
            add_custom_command(OUTPUT ${gen_file_tpl} ${include_file_h}
                               COMMAND ${GXTEXCONV_EXE} ARGS -s ${scf_file} -o ${gen_file_tpl}
                               COMMAND ${CMAKE_COMMAND} -E copy ARGS ${gen_file_h} ${include_file_h}
                               COMMAND ${CMAKE_COMMAND} -E rm ARGS ${gen_file_h})

        endforeach(scf_file)

        # Create target
        add_custom_target(${target_name} SOURCES "${scf_files};${gen_files_tpl};${include_files_h}")

        # Set variables in parent scope for custom target outputs
        set("${target_name}_TPL" ${gen_files_tpl} PARENT_SCOPE)
        set("${target_name}_H" ${include_files_h} PARENT_SCOPE)

    endfunction(add_gxtexconv_target)
endif()
