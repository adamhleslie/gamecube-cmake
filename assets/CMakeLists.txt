# Defines assets_gxtexconv_interface
add_subdirectory(textures)
get_target_property(gxtexconv_files assets_gxtexconv_interface GXTEXCONV_TPL_FILES)

# bin2s - Binary Files
include(devkitpro.bin2s)
add_bin2s_library(assets_bin2s_library "${gxtexconv_files}")
add_dependencies(assets_bin2s_library assets_gxtexconv_interface)
target_link_libraries(assets_bin2s_library INTERFACE assets_gxtexconv_interface)

include(devkitpro.gamecube)
if(${WII})
    setup_wii_target_options(assets_bin2s_library)
else()
    setup_gamecube_target_options(assets_bin2s_library)
endif()