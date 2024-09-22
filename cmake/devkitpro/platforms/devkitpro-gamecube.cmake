include_guard(GLOBAL)
# OUT: devkitpro::gamecube interface library providing compile and link options

block(SCOPE_FOR VARIABLES)
    add_library(devkitpro::gamecube INTERFACE IMPORTED)
    set(arch_flags "-mogc" "-mcpu=750" "-meabi" "-mhard-float")
    set(definitions "GEKKO")
    target_compile_options(devkitpro::gamecube
            INTERFACE ${arch_flags}
    )
    target_link_options(devkitpro::gamecube
            INTERFACE ${arch_flags}
    )
    target_compile_definitions(devkitpro::gamecube
            INTERFACE ${definitions}
    )
endblock()
