shader_type canvas_item;

uniform float amplitude = 1.0;
uniform bool alive = true;

uniform float AmpMultiplyer_1 = .3;
uniform float TimeMultiplyer_1 = 1.0;

uniform float AmpMultiplyer_2 = .05;
uniform float TimeMultiplyer_2 = 20.0;

void fragment(){
	float dist = sqrt(pow(UV.x - .5,2) + pow(UV.y-.5,2));
	
	float changeX = UV.x - cos((TIME + UV.y) * TimeMultiplyer_1) * (.5-dist) * AmpMultiplyer_1;
	float changeY = UV.y - sin((TIME + UV.x) * TimeMultiplyer_1) * (.5-dist) * AmpMultiplyer_1;
	
	changeX -=cos((TIME + UV.y) * TimeMultiplyer_2) * (.5-dist) * AmpMultiplyer_2;
	changeY -=sin((TIME + UV.x) * TimeMultiplyer_2) * (.5-dist) * AmpMultiplyer_2;
	
	vec4 c = texture(TEXTURE,vec2(changeX,changeY));
	
	
	COLOR = c;
}