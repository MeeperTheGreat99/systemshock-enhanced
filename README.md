System Shock Enhanced - based on Shockolate
============================
Based on the source code for PowerPC released by Night Dive Studios, Incorporated.

GENERAL NOTES
=============

Shockolate is a cross-platform source port of System Shock, using SDL2. This runs well on Linux and Windows right now,
with some missing features that need reviving due to not being included in the source code that was released.

The end goal for this project is something like what Chocolate Doom is for Doom:
an experience that closely mimics the original, but portable and with some quality-of-life improvements,
including an OpenGL renderer and mod support!

This version of Shockolate is going to have some extra stuff. It is described below.


- Preferences and Keybinds are now stored in the game folder, next to the executable,
- New or changed Controls/Keybinds are outlined at the bottom of this readme file.
- Added an optional window icon: shock.bmp. I made a default one that comes with the source code and will work as long as it is in the same folder as the executable, which it is by default. You may delete it or replace it with your own if you choose.

Added Features so far:
======================

- **_Toggleable Persistent Mouselook (Keep MLook)_**  
Default: Off  
Description: Located in the options menu. When on, your mouse will stay locked to the center of the screen when picking up an item or opening a container. I added this because I prefer to play that way, locking and unlocking the mouse manually, and so do some other people. It's mainly for muscle memory actually.

- **_Keyboard Keypad Support_**  
Description: Changes in-game keypad binds to use your keyboard's keypad instead of the row of number keys at the top. That way, the number keys are still availible for toggling hardware implants.

- **_Extra Digital Audio Channels_**  
Default: 32  
Description: Normally, you may choose from 2, 4, or 8 digital audio channels in the audio options. Now, you may additionally choose 16 or 32 channels. I added this because there are semi-rare cases when all channels are easily filled up, such as the room with all the Z-44 Plastique (TM) on the Storage level. Now I know 32 is totally overkill, but who knows? Maybe someday there will be a reason to have 32 channels.

- **_Field of View Slider_**  
Default: 80  
Description: Located in video options menu. Adds an FOV slider that ranges from 70 to 135 degrees.  
Note: FOV cannot be changed while using the OpenGL renderer. It will stay at the default 80. This is because changing FOV causes a crash in certain areas when using the OpenGL renderer.

- **_Main Menu Button_**  
Description: Located in the pause menu. This button will return you directly to the main menu that is shown upon starting the game. Keep in mind that it will not ask for confirmation and instead will immediately send you there upon clicking it.

- **_Quick Use/Pickup Key_**  
Default: `C`  
Description: Adds a key which will instantly pickup and add an object you are looking at to your inventory, or use the object if it cannot be picked up.

- **_Fullscreen Video Option_**  
Default: Off  
Description: Located in the video prefs menu. Adds a button which toggles fullscreen and saves your preference inside the prefs file. Pressing `Alt+Enter` also saves the new fullscreen state. The launch options, `-fullscreen` or `-windowed` may also be specified when starting the game in order to run in the selected mode. Setting launch options will not change the saved mode in the prefs file.

Planned and/or WIP Features:
============================

- ~~**_Field of View Slider_**~~ Finished  
- ~~**_Quick Use/Pickup Key_**~~ Finished  
- ~~**_Fullscreen Video Option & `-windowed` or `-fullscreen` launch options_**~~ Finished
- **_Widescreen Resolutions and Custom Width/Height Resolutions_** (Don't expect that anytime soon, I'm quite new to this. But I'll do my best.)  
- **_Mouselook Pausing Stance Change Fix_** (this is an issue where you cannot lean or change stance while mouselooking horizontally)

Important Requirements
======================

  - CD-ROM or SS:EE `DATA` folder in a `res` folder next to the executable
    - Floppy disk assets cannot be loaded.
  - If you have the Steam release, System Shock: Classic, you can go into `steamapps/common/SS1/SSHOCK` and find the `DATA` folder there.
    - The `SOUND` folder may also be found there. It is optional, but required if you want music. It goes inside `res` alongside `DATA`.


Running
=======

## 1) Acquire binary
### From a prebuilt package

Find a list of [downloadable packages](https://github.com/Interrupt/systemshock/releases/) for Linux and Windows.
32- and 64-bit versions are available for Linux and Windows.

### From source code

See [COMPILING.md](COMPILING.md) in the repository.

## 2) Provide resources

### 2a) Game data
Original cd-rom or SS:EE assets in a `res/data` folder need to be next to the executable.
> Floppy disk assets are an older version that we can't load currently.

### 2b) Music sound font (optional)
In the `res` folder, add a `.sf2` sound font file that should be used for playback.

> There is a file on the internet that's close to the Windows default everyone knows: http://rancid.kapsi.fi/windows.sf2
> Please note that this is a file of unknown provenance.

## 3) Execute binary

```
./systemshock
```

### Command line parameters

`-nosplash` Disables the splash screens, causes the game to start straight to the main menu  
`-fullscreen` Forces the game to start in fullscreen mode  
`-windowed` Forces the game to start in windowed mode

Modding Support
============
Shockolate supports loading mods and full on fan missions.
Point the executable at a mod file or folder and the game will load it in.
So far mod loading supports additional `.res` and `.dat` files for resources and missions respectively.

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

## Movement

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

## Interaction

- `MOUSE1` to inspect objects
- `MOUSE1`x2 to use/pickup objects
- `C` to use/put object into inventory

## MFD (Multifunctional Display)

- `F1`-`F10` to activate/deactivate MFD panels  
- `1`-`10` to activate/deactivate hardware implants  

## Additional hotkeys

* `Ctrl+G` cycles between graphics rendering modes  
* `Ctrl+F` to enable full screen mode  
* `Ctrl+D` to disable full screen mode

