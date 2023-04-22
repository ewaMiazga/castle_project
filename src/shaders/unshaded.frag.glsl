precision mediump float;
		
// Texture coordinates passed from vertex shader
varying vec2 v2f_uv;

// Texture to sample color from
uniform sampler2D tex_color;

uniform float color_factor;

void main()
{
	/* #TODO GL3.1.1
	Sample texture tex_color at UV coordinates and display the resulting color.
	*/
	vec2 uv = v2f_uv;
	vec4 color = texture2D(tex_color, uv);

	//vec3 color = vec3(v2f_uv, 0.);

	color *= color_factor; // this allows us to reuse this shader for ambient pass
	gl_FragColor = vec4(color.xyz, 1.); // output: RGBA in 0..1 range
}
