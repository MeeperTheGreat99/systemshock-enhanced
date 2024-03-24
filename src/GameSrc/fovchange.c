#include "fovchange.h"
#include <fullscrn.h>
#include <Prefs.h>
#include <OpenGL.h>

short current_fov = 0;
short max_fov = 120;
short min_fov = 60;

void update_fov(void) {
#ifdef USE_OPENGL
	if (use_opengl())
		opengl_remake_projection_matrix();
#endif

	if (full_game_3d)
		fullscreen_start();
	else
	{
		fullscreen_start();
		fullscreen_exit();
		change_svga_screen_mode();
	}
}

void set_fov(short fov, unsigned char save) {
	current_fov = fov;
	if (current_fov < min_fov)
		current_fov = min_fov;
	if (current_fov > max_fov)
		current_fov = max_fov;
	
	if (save)
		gShockPrefs.doFov = current_fov;
}

void set_fov_slider(short fov) {
	float frac = (float)fov / 255.0f;
	set_fov(min_fov + (short)(frac * (float)(max_fov - min_fov)), TRUE);
}

short get_fov(void) {
	return current_fov;
}

short get_fov_slider(void) {
	return (short)(255.0f * (float)(get_fov() - min_fov) / (float)(max_fov - min_fov));
}