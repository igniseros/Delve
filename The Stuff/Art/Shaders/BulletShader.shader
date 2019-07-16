shader_type canvas_item;

uniform vec4 tint : hint_color;

void fragment(){
	vec4 c = texture(TEXTURE, UV);
	
	c *= tint;
	
	COLOR = c;
}