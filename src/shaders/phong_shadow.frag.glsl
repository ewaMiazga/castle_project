precision highp float;

varying vec3 surface_normal;
varying vec2 v2f_uv; 
varying vec3 trans_vertex;

uniform vec3 material_color;
uniform float material_shininess;

uniform vec3 light_position; // light position in camera coordinates
uniform vec3 light_color;
uniform samplerCube cube_shadowmap;
uniform sampler2D tex_color;

void main() {

	float material_shininess = 12.;

	/* #TODO GL3.1.1
	Sample texture tex_color at UV coordinates and display the resulting color.
	*/
	
	vec3 material_color = texture2D(tex_color, v2f_uv).xyz;
	
	/*
	#TODO GL3.3.1: Blinn-Phong with shadows and attenuation

	Compute this light's diffuse and specular contributions.
	You should be able to copy your phong lighting code from GL2 mostly as-is,
	though notice that the light and view vectors need to be computed from scratch here; 
	this time, they are not passed from the vertex shader. 
	Also, the light/material colors have changed; see the Phong lighting equation in the handout if you need
	a refresher to understand how to incorporate `light_color` (the diffuse and specular
	colors of the light), `v2f_diffuse_color` and `v2f_specular_color`.
	
	To model the attenuation of a point light, you should scale the light
	color by the inverse distance squared to the point being lit.
	
	The light should only contribute to this fragment if the fragment is not occluded
	by another object in the scene. You need to check this by comparing the distance
	from the fragment to the light against the distance recorded for this
	light ray in the shadow map.
	
	To prevent "shadow acne" and minimize aliasing issues, we need a rather large
	tolerance on the distance comparison. It's recommended to use a *multiplicative*
	instead of additive tolerance: compare the fragment's distance to 1.01x the
	distance from the shadow map.

	Implement the Blinn-Phong shading model by using the passed
	variables and write the resulting color to `color`.

	Make sure to normalize values which may have been affected by interpolation!
	*/

	float distance_scaling = 1.0 / (length(trans_vertex - light_position) * length(trans_vertex - light_position));
	vec3 ambient = 0.1 * material_color;

	vec3 light_direction = normalize(light_position - trans_vertex);
	vec3 object_normal = normalize(surface_normal);
	vec3 direction_to_camera = normalize(-trans_vertex);

	vec3 specular = vec3(0.);
	vec3 diffuse = vec3(0.);
	vec3 h = vec3(0.);
	vec3 Il_Ms = vec3(0.);

	
	if(dot(object_normal, light_direction) >= 0.0) { 
		// Diffuse reflection

		Il_Ms = light_color * material_color;

		diffuse = distance_scaling * Il_Ms * dot(object_normal, light_direction);
	
		h = normalize(direction_to_camera + light_direction);
	
		if (dot(object_normal, h) >= 0.0) {
			// Specular Reflection
			specular = distance_scaling * Il_Ms * pow(max(dot(object_normal, h), 0.0), 
			material_shininess);
		}
	}

	float z = (textureCube(cube_shadowmap, normalize(trans_vertex - light_position))).z;
	
	float exposed = 0.0;
	float epsilon = 1e-1;

	float intersection_distance = length(trans_vertex - light_position);

	if (intersection_distance <= 1.01*z) {
		exposed = 1.0;
	}

	vec3 color = ambient + exposed * (diffuse + specular);
	gl_FragColor = vec4(color, 1.); // output: RGBA in 0..1 range
}
