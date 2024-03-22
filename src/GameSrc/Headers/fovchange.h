#ifndef FOVCHANGE_H
#define FOVCHANGE_H

void global_update_fov();
void opengl_remake_projection_matrix();
extern short global_fov;
extern short saved_fov;
extern short max_fov;
extern short min_fov;

#endif