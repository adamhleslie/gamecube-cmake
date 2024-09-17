# OUT: Defines add_dol_custom function for creating an executable

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
    function(add_dol_custom target dol_file_name source_file)

        cmake_path(APPEND dol_file ${CMAKE_CURRENT_BINARY_DIR} ${dol_file_name})

        add_custom_command(
                OUTPUT ${dol_file}
                DEPENDS ${source_file}
                COMMAND ${ELF2DOL_EXE} ${source_file} ${dol_file}
        )
        add_custom_target(${target}
                ALL
                DEPENDS ${dol_file}
        )

        # Log Target Info
        message(VERBOSE ${target})
        message(VERBOSE "    Source File: ${source_file}")
        message(VERBOSE "    .dol File: ${dol_file}")

    endfunction(add_dol_custom)
endif()
