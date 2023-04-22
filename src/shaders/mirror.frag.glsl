precision mediump float;

/* #TODO GL3.2.3
	Setup the varying values needed to compue the Phong shader:
	* surface normal
	* view vector: direction to camera
*/
varying vec3 surface_normal;
varying vec3 view_vec;
varying vec3 light_vec;

uniform samplerCube cube_env_map;

void main()
{
	/*
	/* #TODO GL3.2.3: Mirror shader
	Calculate the reflected ray direction R and use it to sample the environment map.
	Pass the resulting color as output.
	*/

	vec3 light_direction = normalize(light_vec);
	vec3 object_normal = normalize(surface_normal);
	vec3 direction_to_camera = normalize(view_vec);

	vec4 result = vec4(0.);
	vec3 reflect_direction = reflect(-direction_to_camera, object_normal);
	result = textureCube(cube_env_map, reflect_direction);

	gl_FragColor = vec4(result.xyz, 1.); // output: RGBA in 0..1 range
}
