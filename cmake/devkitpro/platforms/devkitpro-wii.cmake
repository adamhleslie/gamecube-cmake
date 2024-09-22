include_guard(GLOBAL)
# OUT: devkitpro::wii interface library providing compile and link options

block(SCOPE_FOR VARIABLES)
    add_library(devkitpro::wii INTERFACE IMPORTED)
    set(arch_flags "-mrvl" "-mcpu=750" "-meabi" "-mhard-float")
    set(definitions "GEKKO")
    target_compile_options(devkitpro::wii
            INTERFACE ${arch_flags}
    )
    target_link_options(devkitpro::wii
            INTERFACE ${arch_flags}
    )
    target_compile_definitions(devkitpro::wii
            INTERFACE ${definitions}
    )
endblock()
