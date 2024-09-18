# TODO
- Continued modernization of cmake code
  - Add config-file and find module implementations for dkp
- Branches for various template projects
- Generate linker map file
- Dolphin gdb stub run command
- Readme :)
- Consider adding CMakePresets.json

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
