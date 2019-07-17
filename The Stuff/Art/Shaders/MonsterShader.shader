shader_type canvas_item;

uniform float hitLeft = 0.0;

void fragment(){
	vec4 c = texture(TEXTURE, UV);
	
	vec4 white = vec4(1,1,1,c.a);
	
	c = mix(c,white, hitLeft);
	
	COLOR = c;
}