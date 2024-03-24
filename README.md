System Shock Enhanced - based on Shockolate
============================
Based on the source code for PowerPC released by Night Dive Studios, Incorporated.

[![Build Status TravisCI](https://travis-ci.org/Interrupt/systemshock.svg?branch=master)](https://travis-ci.org/Interrupt/systemshock) [![Build Status AppVeyor](https://ci.appveyor.com/api/projects/status/5fmcswq8n7ni0o9j/branch/master?svg=true)](https://ci.appveyor.com/project/Interrupt/systemshock)

GENERAL NOTES
=============

This version of Shockolate is going to have some extra stuff. It is described below.

Changes:
========

- Preferences and Keybinds are now stored in the game folder, next to the executable,
- New or changed Controls/Keybinds are outlined at the bottom of this readme file.
- Added an optional window icon: shock.bmp. I made a default one that comes with the source code and will work as long as it is in the same folder as the executable, which it is by default. You may delete it or replace it with your own if you choose.
- There is also a Windows only (I think at least. I'm getting a Linux VM soon so I can see how icons work there) icon.rc file for use when building systemshock.exe. If it doesn't compile or something and you can't figure out a fix, remove the WIN32_RESOURCES variable from line 388 of CMakeLists.txt. This will build the executable without an icon.

Added Features so far:
======================

- **_Persistent Mouselook Toggle (Keep MLook)_**  
Default: Off  
Location: Options  
Description: If enabled, your cursor will stay locked to the center of the screen when interacting with anything. If locking/unlocking the mouselook manually is your thing, this is for you.

- **_Keyboard Keypad Support_**  
Description: Changes in-game keypad binds to use your keyboard's keypad instead of the row of number keys at the top. That way, the number keys are still availible for toggling hardware implants.

- **_Extra Digital Audio Channels_**  
Default: 4  
Location: Audio options  
Description: Normally, you may choose from 2, 4, or 8 digital audio channels. But this is the 21st century, we have _much_ more than a measily 8 channels available on modern hardware. Now, you may additionally choose 16 or 32 channels. Justifiable, because there are semi-rare cases when all channels are easily filled up, such as the room with all the Z-44 Plastique (TM) on the Storage level. Now I know 32 is totally overkill for ol 'Shock, and so you may ask "why?". And to that I say, science isn't about why. It's about why not.

- **_Field of View Slider_**  
Default: 80  
Location: Video preferences  
Description: A camera field of view slider that ranges from 60 to 120 degrees.  
Note: ~~FOV cannot be changed while using the OpenGL renderer. It will stay at the default 80. This is because changing FOV causes a crash in certain areas when using the OpenGL renderer.~~ This is no longer an issue. (Yippie!!!)

- **_Main Menu Button_**  
Location: Pause menu  
Description: This button will send you straight to the main menu that is shown upon starting the game, no detours or restarts. There is now a yes/no confirmation when clicking the button.

- **_Quick Use/Pickup Key_**  
Default: `C`  
Description: A key which will instantly pickup and add an object you are looking at to your inventory, or use the object if it cannot be picked up.

- **_Fullscreen Toggle_**  
Default: Off  
Location: Video preferences  
Description: When clicked, the button toggles the game into or out of a fullscreen window. It also saves your preference. Pressing `Alt+Enter` functions the exact same. The launch options, `-fullscreen` or `-windowed` may also be specified when starting the game in order to force it to run in the desired mode. However, these launch options will not change the saved preference mode.

Planned and/or WIP Features:
============================

- ~~**_Field of View Slider_**~~ Finished  
- ~~**_Quick Use/Pickup Key_**~~ Finished  
- ~~**_Fullscreen Video Option & `-windowed` or `-fullscreen` launch options_**~~ Finished  
- **_Widescreen Resolutions and Custom Width/Height Resolutions_** (Not such a far fetched goal these days!)  
- **_Mouselook Pausing Stance Change Fix_** (This is an issue where you cannot lean or change stance while mouselooking horizontally)
- **_SSHOCK 2 Mode Toggle_** (Eventually I'll implement the more streamlined control system from System Shock 2 and add it as an option)

Important Requirements
======================

  - CD-ROM or SS:EE `DATA` folder in a `res` folder next to the executable
    - Floppy disk assets cannot be loaded.
  - If you have the Steam release, System Shock: Classic, you can go into `steamapps/common/SS1/SSHOCK` and find the `DATA` folder there.
    - The `SOUND` folder may also be found there. It is optional, but required if you want music. It goes inside `res` alongside `DATA`.


Running
=======

## From a prebuilt package

There will be builds for Windows and Linux, but I don't have a Mac. The available releases can be found [here](https://github.com/MeeperTheGreat99/systemshock-enhanced/releases).

## From source code

Prerequisites: 
- [CMake](https://cmake.org/download/) installed

Step 1. Build the dependencies:
* Windows: `build_win32.sh` or `build_win64.sh` (Git Bash and MinGW recommended)
* Linux/Mac: `build_deps.sh` or the CI build scripts in `osx-linux`
* Other: `build_deps.sh` 

Step 2. Build and run the game itself - Note: Windows users either need to install Make for Windows (That's what I did) or just switch "make" for "mingw32-make" in the command.
```
cmake -G "Unix Makefiles" .
make systemshock
./systemshock
```

The following CMake options are supported in the build process:
* `ENABLE_SDL2` - use system or bundled SDL2 (ON/BUNDLED, default BUNDLED)
* `ENABLE_SOUND` - enable sound support (requires SDL2_mixer, ON/BUNDLED/OFF, default is BUNDLED)
* `ENABLE_FLUIDSYNTH` - enable FluidSynth MIDI support (ON/BUNDLED/OFF, default is BUNDLED)
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
- `TAB` to switch to next weapon
- `SHIFT`+`TAB` to switch to previous weapon
- `MWHEELDOWN` to switch to next weapon
- `MWHEELUP` to switch to previous weapon

## World Interaction

- `MOUSE1` to inspect objects
- `MOUSE1`x2 to use/pickup objects
- `C` to use/put object into inventory

## MFDs (Multifunctional Displays) & Neural Interface

- `F1`-`F10` to activate/deactivate MFD panels  
- `1`-`10` to toggle hardware implants  

## Miscellaneous Hotkeys

* `Ctrl+G` cycles between graphics rendering modes  
* `Ctrl+F` to enable full screen mode  
* `Ctrl+D` to disable full screen mode

