# Defines gxtexconv_interface
add_subdirectory(textures)
get_target_property(gxtexconv_files gxtexconv_interface GXTEXCONV_TPL_FILES)

# bin2s - Binary Files
include(devkitpro.bin2s)
add_bin2s_library(bin2s_library "${gxtexconv_files}")
add_dependencies(bin2s_library gxtexconv_interface)
target_link_libraries(bin2s_library INTERFACE gxtexconv_interface)
