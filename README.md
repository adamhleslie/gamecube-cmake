# TODO
- Binary Data w/ bin2o, a la grit
- Rename bin2o and gxtexconv inputs function inputs and vars away from gen/include dichotomy, and towards more clear and specific naming
- Generate linker map file
- Dolphin gdb stub run command
- Readme :)
- reliance on https://github.com/extremscorner/pacman-packages ?

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
