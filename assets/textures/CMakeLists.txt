set(scf_files
        textures.scf
)

include(devkitpro-gxtexconv)
add_gxtexconv_interface(assets_gxtexconv_interface "${scf_files}")
