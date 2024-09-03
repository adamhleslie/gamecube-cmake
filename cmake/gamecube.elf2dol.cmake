# OUT: Defines add_dol_target function for creating an executable

if(NOT ELF2DOL_EXE)
    message(STATUS "Looking for elf2dol")
    find_program(ELF2DOL_EXE elf2dol)
    if(ELF2DOL_EXE)
        message(STATUS "    Found -- ${ELF2DOL_EXE}")
    else()
        message(FATAL_ERROR "    Could not find elf2dol")
    endif()
endif()

if(ELF2DOL_EXE)
    function(add_dol_target file_name source_target_name copy_dol_to_source_dir source_target_path)
        
        set(dol_file ${file_name}.dol)
        set(dol ${CMAKE_CURRENT_BINARY_DIR}/${dol_file})
        set(dol_copy ${CMAKE_SOURCE_DIR}/${dol_file})
        set(source ${CMAKE_CURRENT_BINARY_DIR}/${source_target_path})

        if(copy_dol_to_source_dir)
            add_custom_command(OUTPUT ${dol} ${dol_copy}
                               DEPENDS ${source}
                               COMMAND ${ELF2DOL_EXE} ARGS ${source} ${dol}
                               COMMAND ${CMAKE_COMMAND} -E copy ARGS ${dol} ${dol_copy})

            add_custom_target(${dol_file} ALL
                              DEPENDS ${dol} ${dol_copy})
        else()
            add_custom_command(OUTPUT ${dol}
                               DEPENDS ${source}
                               COMMAND ${ELF2DOL_EXE} ${source} ${dol})

            add_custom_target(${dol_file} ALL
                              DEPENDS ${dol})
        endif()

        add_dependencies(${dol_file}
                         ${source_target_name})

    endfunction(add_dol_target)
endif()
