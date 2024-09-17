include(devkitpro.gxtexconv)

set(scf_files
        textures.scf
)

set(image_files
        ballsprites.png
)

add_gxtexconv_interface(gxtexconv_interface "${scf_files}" "${image_files}")
