Shockolate - System Shock Enhanced
========
Based on the source code for PowerPC released by Night Dive Studios, Incorporated.

[![Build Status TravisCI](https://travis-ci.org/Interrupt/systemshock.svg?branch=master)](https://travis-ci.org/Interrupt/systemshock) [![Build Status AppVeyor](https://ci.appveyor.com/api/projects/status/5fmcswq8n7ni0o9j/branch/master?svg=true)](https://ci.appveyor.com/project/Interrupt/systemshock)

GENERAL NOTES
========

Join the official [Shockolate Discord](https://discord.gg/m45xPan) to follow along with development!

![work so far](https://i.imgur.com/kbVWQj4.gif)

This version of Shockolate has a lot of changes, and some extra stuff. It is listed below.

Changes/Fixes:
========

- Preferences and Keybinds are now stored in the game folder, next to the executable.
- The mouselook stance freeze bug has been stomped (finally).

Features:
========

- **_Persistent Mouselook Toggle_**  
Default: Off  
Location: Input->Mouselook  
Description: If enabled, your cursor will stay locked to the center of the screen when interacting with anything. If locking/unlocking the mouselook manually is your thing, this is for you.

- **_Physical Keypad Support_**  
Description: The in-game keypads are now controlled by your physical keyboard's keypad instead of the row of number keys at the top. This way, the number keys are still availible for toggling hardware implants.

- **_Extra Digital Audio Channels_**  
Default: 16  
Location: Audio  
Description: After a long period of thought, I realize this may not actually do anything anymore. In any case, you have up to 16 digital audio channels now.

- **_Field of View Slider_**  
Default: 80  
Location: Video->Prefs  
Description: A camera field of view slider that ranges from 60 to 120 degrees.

- **_Main Menu Button_**  
Location: Pause menu  
Description: This button will send you straight to the main menu that is shown upon starting the game, no restarts required. There is a yes/no confirmation when clicking the button.

- **_Control Schemes_**  
Default: SShock 1  
Location: Input  
Description: Now you can choose between the System Shock 1 mouse controls OR the System Shock 2 mouse controls. It's game changer. Literally.

- **_Fullscreen Toggle_**  
Default: Off  
Location: Video->Prefs  
Description: When clicked, the button toggles the game into or out of a fullscreen window. It also saves your preference. Pressing `Alt+Enter` functions the exact same. The launch options, `-fullscreen` or `-windowed` may also be specified when starting the game in order to force it to run in the respective mode.

Planned/WIP
========

- Custom/High Resolutions (One day I will win against the RES library)

Important Requirements
========
  - CD-ROM or SS:EE `DATA` folder in a `res` folder next to the executable
    - Floppy disk assets cannot be loaded.
  - If you have the Steam release, System Shock: Classic, you can go into `steamapps/common/SS1/SSHOCK` and find the `DATA` folder there.
    - The `SOUND` folder may also be found there. It is optional, but required if you want music. It goes inside `res` alongside `DATA`.

Running
=======

## From a prebuilt package

There will be builds for Windows and Linux, but I don't have a Mac. The available releases can be found [here](https://github.com/MeeperTheGreat99/systemshock-enhanced/releases).

## From source code

Build Prequisites: 
Ninja and Clang were chosen to maximize build speed.
- [CMake](https://cmake.org/download/)
- [Ninja Build System](https://github.com/ninja-build/ninja/releases)
- [Clang C/C++ compiler](https://releases.llvm.org/download.html)


Step 1. Download and build dependencies:
* Run the shell script `get_libs.sh` to download all required libraries and then build them using CMake, Ninja, and Clang

Step 2. Build and run the game
* Run the shell script `build_release.sh` to build the game, or `build.sh` if you want to build in debug mode instead.
* `./systemshock`

The following CMake options are supported in the build process, though you will have to edit the `build.sh` script to change them:
* `ENABLE_SDL2` - enable SDL2 support (ON/OFF, default ON) - FYI, the game will probably not build with this off
* `ENABLE_SOUND` - enable SDL2_mixer sound support (ON//OFF, default ON)
* `ENABLE_FLUIDSYNTH` - enable FluidSynth MIDI support (ON/OFF, default ON)
* `ENABLE_OPENGL` - enable OpenGL support (ON/OFF, default ON)

If you find yourself needing to modify the build script for Shockolate itself, `CMakeLists.txt` is the place to look into.

Command line parameters
============

`-nosplash` Disables the splash screens, causes the game to start straight to the main menu  
`-fullscreen` Forces the game to start in fullscreen mode  
`-windowed` Forces the game to start in windowed mode

Modding Support
============
Shockolate supports loading mods and full on fan missions. Just point the executable at a mod file or folder and the game will load it in. So far mod loading supports additional `.res` and `.dat` files for resources and missions respectively.

Run a fan mission from a folder:
```
./systemshock /Path/To/My/Mission
```

Run a fan mission from specific files:
```
./systemshock my-archive.dat my-strings.res
```

Controls
=======

## Movement & View

- `WASD` to move
- `F` to toggle mouselook
- `Q` and `E` to lean left or right
- `T`, `G` and `B` to stand, crouch, or prone
- `SPACE` to jump

## Weapons

- `MOUSE2` to fire/attack with weapon
- `R` to reload weapon
- `V` to swap weapon ammo type
- `MWHEELDOWN` or `TAB` to switch to next weapon
- `MWHEELUP` or `SHIFT`+`TAB` to switch to previous weapon

## World Interaction

- `MOUSE1` to inspect objects
- `MOUSE1`x2 to use/pickup objects

## MFDs (Multifunctional Displays) & Neural Interface

- `F1`-`F10` to activate/deactivate MFD panels  
- `1`-`10` to toggle hardware implants  

## Miscellaneous Hotkeys

* `Ctrl+G` cycles between graphics rendering modes  
* `Ctrl+F` to enable full screen mode  
* `Ctrl+D` to disable full screen mode
