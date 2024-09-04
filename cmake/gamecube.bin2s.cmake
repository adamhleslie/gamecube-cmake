# OUT: Defines add_bin2o_target function for converting binary files to object files
#   - Sets variables ${target_name}_O and ${target_name}_H in parent scope for referencing custom target outputs

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
    function(add_bin2o_target binary_files gen_path include_path)

        # Create target directories
        file(MAKE_DIRECTORY ${gen_path})
        file(MAKE_DIRECTORY ${include_path})

        # Add a command to process each file with bin2s
        foreach(binary_file ${binary_files})

            get_filename_component(binary_filename_we ${binary_file} NAME_WE)
            get_filename_component(binary_extension ${binary_file} EXT)

            string(REPLACE "." "_" object_suffix ${binary_extension})
            set(include_file_h "${include_path}/${binary_filename_we}${object_suffix}.h)
            set(gen_file_o "${gen_path}/${binary_filename_we}${object_suffix}.o)

            # Mark as generated files
            set_source_files_properties("${include_file_h}" PROPERTIES GENERATED TRUE)
            set_source_files_properties("${gen_file_o}" PROPERTIES GENERATED TRUE)

            # Append to files list
            set(include_files_h ${include_files_h} ${include_file_h})
            set(gen_files_o ${gen_files_o} ${gen_file_o})

            # TODO: Create bin2o command
            # bin2o from base_tools:
            ##---------------------------------------------------------------------------------
            ## canned command sequence for binary data
            ##---------------------------------------------------------------------------------
            #define bin2o
            #$(eval _tmpasm := $(shell mktemp))
            #$(SILENTCMD)bin2s -a 32 -H `(echo $(<F) | tr . _)`.h $< > $(_tmpasm)
            #$(SILENTCMD)$(CC) -x assembler-with-cpp $(CPPFLAGS) $(ASFLAGS) -c $(_tmpasm) -o $(<F).o
            #@rm $(_tmpasm)
            #endef

            # TODO REFACTOR: Write asm files directly to gen folder, create static library, with target_compile_options OR set_target_properties COMPILE_FLAGS
            #add_custom_command(OUTPUT ${include_file_h} ${gen_file_o}
            #                   COMMAND ${BIN2S_EXE} ARGS -a 32 -H ${include_file_h} ${binary_file} > )

        endforeach(binary_file)

        # Create targets
        add_library(${target_name} OBJECT IMPORTED)
        set_target_properties(${target_name} PROPERTIES IMPORTED_OBJECTS ${gen_files_o})

        add_custom_target("${target_name}_include" SOURCES "${binary_files};${include_files_h}")

    endfunction(add_bin2o_target)
endif()
