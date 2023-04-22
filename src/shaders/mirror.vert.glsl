// Vertex attributes, specified in the "attributes" entry of the pipeline
attribute vec3 vertex_position;
attribute vec3 vertex_normal;

// Per-vertex outputs passed on to the fragment shader

/* #TODO GL3.2.3
	Setup the varying values needed to compute the Phong shader:
	* surface normal
	* view vector: direction to camera
*/
varying vec3 surface_normal;
varying vec3 view_vec;
varying vec3 light_vec;
varying vec2 v2f_uv;

// Global variables specified in "uniforms" entry of the pipeline
uniform mat4 mat_mvp;
uniform mat4 mat_model_view;
uniform mat3 mat_normals_to_view;


void main() {
	/** #TODO GL3.2.3:
	Setup all outgoing variables so that you can compute reflections in the fragment shader.
	You will need to setup all the uniforms listed above, before you
    can start coding this shader.
	* surface normal
	* view vector: direction to camera
    Hint: Compute the vertex position, normal in eye space.
    Hint: Write the final vertex position to gl_Position
    */
	// viewing vector (from camera to vertex in view coordinates), camera is at vec3(0, 0, 0) in cam coords
	vec3 trans_vertex = (mat_model_view * vec4(vertex_position, 1.)).xyz;
	view_vec = normalize(-trans_vertex);
	
	// transform normal to camera coordinates
	vec3 v2f_normal = mat_normals_to_view * vertex_normal;
	surface_normal = normalize(v2f_normal);

	gl_Position = mat_mvp * vec4(vertex_position, 1);
}
