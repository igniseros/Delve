shader_type canvas_item;

uniform float brightness = 1.0;
uniform float contrast = 1.0;
uniform float saturation = 1.0;
uniform bool enabled = true;

void fragment() {
	if (!enabled){discard;}
	
	vec3 c = texture(SCREEN_TEXTURE, SCREEN_UV).xyz;
	c = texture(TEXTURE, SCREEN_UV).xyz;
	
	
	
	c.rgb = mix(vec3(0.0), c.rgb, brightness);
	c.rgb = mix(vec3(0.5), c.rgb, contrast);
	//sqrt( 0.299*R^2 + 0.587*G^2 + 0.114*B^2 )
	float totalB = sqrt(pow(c.x * 0.299,2) + pow(c.y * 0.587,2) + pow(c.z * 0.114,2));
	float newSat = saturation - (totalB / 2.0);
	if (newSat < 0.0){newSat = 0.0;}
	c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, newSat);
	//c.rgb = vec3(newSat,newSat,newSat);
	//c.rgb = vec3(totalB,totalB,totalB);
	   
	
	COLOR.xyz = c;
}