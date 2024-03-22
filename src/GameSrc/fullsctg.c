#include "fullsctg.h"
#include "Prefs.h"
#include <SDL.h>

extern SDL_Window *window;

bool fullscreenActive = false;

bool getFullscreenActive() {
	return fullscreenActive;
}

void enterFullscreen(bool changePref) {
	fullscreenActive = true;
	SDL_SetWindowFullscreen(window, SDL_WINDOW_FULLSCREEN_DESKTOP);
	if (changePref) {
		gShockPrefs.doFullscreen = fullscreenActive;
		SavePrefs();
	}
}

void exitFullscreen(bool changePref) {
	fullscreenActive = false;
	SDL_SetWindowFullscreen(window, 0);
	if (changePref) {
		gShockPrefs.doFullscreen = fullscreenActive;
		SavePrefs();
	}
	//if (!(SDL_GetWindowFlags(window) & SDL_WINDOW_MAXIMIZED))
		//SDL_SetWindowPosition(window, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED);
}

void toggleFullscreen(bool changePref) {
    if (fullscreenActive)
		exitFullscreen(changePref);
	else
		enterFullscreen(changePref);
}