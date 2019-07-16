shader_type canvas_item;

uniform float amplitude = 1.0;

void fragment(){
	
	float dist = sqrt(pow(UV.x - .5,2) + pow(UV.y-.5,2));
	
	float changeX = UV.x - cos(TIME + UV.y) * (.5-dist) * .2;
	float changeY = UV.y - sin(TIME + UV.x) * (.5-dist) * .2;
	COLOR = texture(TEXTURE,vec2(changeX,changeY));
}