set(scf_files
        textures/texture_test1/textures_1.scf
        textures/texture_test2/textures_2.scf
        textures/textures.scf
)
devkitpro_add_gxtexconv(assets_gxtexconv "${scf_files}" ${CMAKE_CURRENT_SOURCE_DIR} "gxtexconv")
get_target_property(gxtexconv_files assets_gxtexconv DEVKITPRO_GXTEXCONV_TPL_FILES)

# bin2s - Binary Files
devkitpro_add_bin2s(assets_bin2s "${gxtexconv_files}" "${CMAKE_CURRENT_BINARY_DIR}/gxtexconv" "bin2s")
add_dependencies(assets_bin2s assets_gxtexconv)
target_link_libraries(assets_bin2s INTERFACE assets_gxtexconv)
target_link_libraries(assets_bin2s PRIVATE "devkitpro::$<IF:$<BOOL:${WII}>,wii,gamecube>")
