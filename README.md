# TODO
- Compiler Flags - Put into set_gamecube_target macro, like arm7 and arm9 macros set LINKER and COMPILER flags based on nds makefiles
- Targets
- elf2dol, gxtexconv
- Binary Data w/ bin2o, a la grit
- Generate linker map file

# nds-cmake
Homebrew Nintendo DS build system

### Features:
- Builds separate arm7 and arm9 binaries
- Shared code between the arm7 and arm9
- Automated PNG conversion through Grit
- Visual Studio 2019 / CLion Support
- Debugging with DeSmuME (Requires development build)

### Necessary Environment Variables:
PROJECT = The name of your project

DEVKITPRO = The install directory of devkitpro
