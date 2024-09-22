# Defines assets_gxtexconv
add_subdirectory(textures)
get_target_property(gxtexconv_files assets_gxtexconv DEVKITPRO_GXTEXCONV_TPL_FILES)

# bin2s - Binary Files
devkitpro_add_bin2s(assets_bin2s "${gxtexconv_files}")
add_dependencies(assets_bin2s assets_gxtexconv)
target_link_libraries(assets_bin2s INTERFACE assets_gxtexconv)

if(${WII})
    target_link_libraries(assets_bin2s PRIVATE devkitpro::wii)
else()
    target_link_libraries(assets_bin2s PRIVATE devkitpro::gamecube)
endif()