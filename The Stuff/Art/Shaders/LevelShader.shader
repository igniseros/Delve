shader_type canvas_item;

uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;

void fragment() {
    vec3 c = texture(TEXTURE, SCREEN_UV).xyz;
	
	
	
	c.rgb = mix(vec3(0.0), c.rgb, brightness);
	c.rgb = mix(vec3(0.5), c.rgb, contrast);
	
	float totalB = (c.x + c.y + c.z) / 3.0;
	totalB *= totalB * totalB;
	totalB *= 2.0;
	float newSat = saturation - (totalB / 1.5);
	if (newSat < 0.0){newSat = 0.0;}
	c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, newSat);
	//c.rgb = vec3(newSat,newSat,newSat);
    COLOR.xyz = c;
}