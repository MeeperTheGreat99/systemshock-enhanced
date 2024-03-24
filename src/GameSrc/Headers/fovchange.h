#ifndef FOVCHANGE_H
#define FOVCHANGE_H

void update_fov(void);
void set_fov(short fov, unsigned char save);
void set_fov_slider(short fov);
short get_fov(void);
short get_fov_slider(void);
void opengl_remake_projection_matrix();

#endif