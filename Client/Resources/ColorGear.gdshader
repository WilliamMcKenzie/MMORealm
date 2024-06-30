shader_type canvas_item;

uniform vec4 line_color : hint_color = vec4(0, 0, 0, 1);
uniform float line_thickness : hint_range(0, 10) = 0.4;
uniform float glow_thickness : hint_range(0, 20) = 1.3;
uniform vec4 glow_color : hint_color = vec4(0, 0, 0, 0.07);

uniform sampler2D helmetTexture;
uniform sampler2D bodyTexture;
uniform sampler2D weaponTexture;

uniform bool helmetTextureActive = false;
uniform bool bodyTextureActive = false;
uniform bool weaponTextureActive = false;

uniform vec4 helmetDarkOrigin:hint_color = vec4(33, 53, 23, 0.2);
uniform vec4 helmetDarkNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 helmetMediumOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 helmetMediumNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 helmetLightOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 helmetLightNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 bodyDarkOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 bodyDarkNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 bodyMediumOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 bodyMediumNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 bodyLightOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 bodyLightNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 bandOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 bandNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 buckleOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 buckleNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 weaponOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 weaponNew:hint_color= vec4(33, 53, 23, 0.2);

uniform vec4 weaponSecondaryOrigin:hint_color= vec4(33, 53, 23, 0.2);
uniform vec4 weaponSecondaryNew:hint_color= vec4(33, 53, 23, 0.2);


void fragment() {
	
    vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
    vec2 glow_size = TEXTURE_PIXEL_SIZE * glow_thickness;
    
    float outline = 0.0;
	vec4 neighborColor;

	// Check each neighboring pixel
	for (float i = -1.0; i <= 1.0; i++) {
	    for (float j = -1.0; j <= 1.0; j++) {
	        if (i == 0.0 && j == 0.0) continue;

	        // Sample the color of the neighboring pixel
	        neighborColor = texture(TEXTURE, UV + vec2(i * size.x, j * size.y));

	        // Accumulate alpha values of non-excluded pixels
	        outline += neighborColor.a;
		}
	}

	outline = min(outline, 1.0);

    float glow = 0.0;
    for (float i = 1.0; i <= glow_thickness; i++) {
        vec2 offset = TEXTURE_PIXEL_SIZE * i;
        glow += texture(TEXTURE, UV + vec2(-offset.x, 0)).a / i;
        glow += texture(TEXTURE, UV + vec2(offset.x, 0)).a / i;
        glow += texture(TEXTURE, UV + vec2(0, -offset.y)).a / i;
        glow += texture(TEXTURE, UV + vec2(0, offset.y)).a / i;
        glow += texture(TEXTURE, UV + vec2(-offset.x, -offset.y)).a / i;
        glow += texture(TEXTURE, UV + vec2(offset.x, -offset.y)).a / i;
        glow += texture(TEXTURE, UV + vec2(-offset.x, offset.y)).a / i;
        glow += texture(TEXTURE, UV + vec2(offset.x, offset.y)).a / i;
    }
    glow = min(glow / glow_thickness, 1.0) - outline;

    vec4 color = texture(TEXTURE, UV);
    vec4 outline_color = mix(color, line_color, outline - color.a);
    vec4 glow_color_mixed = mix(outline_color, glow_color, glow * (1.0 - color.a));
    
    COLOR = glow_color_mixed;
	
	vec4 current_pixel = texture(TEXTURE, UV);
	vec2 scaled_uv = fract(UV * 150.0);

	if(helmetTextureActive == true && (current_pixel == helmetDarkOrigin || current_pixel == helmetLightOrigin || current_pixel == helmetMediumOrigin))
		COLOR = texture(helmetTexture, scaled_uv);
	else {
		if(current_pixel == helmetDarkOrigin)
			COLOR = helmetDarkNew;
		if(current_pixel == helmetLightOrigin)
			COLOR = helmetLightNew;
		if(current_pixel == helmetMediumOrigin)
			COLOR = helmetMediumNew;
	}
	
	if(bodyTextureActive == true && (current_pixel == bodyDarkOrigin || current_pixel == bodyLightOrigin || current_pixel == bodyMediumOrigin))
		COLOR = texture(bodyTexture, scaled_uv);
	else {
		if(current_pixel == bodyLightOrigin)
			COLOR = bodyLightNew;

		if(current_pixel == bodyMediumOrigin)
			COLOR = bodyMediumNew;
		
		if(current_pixel == bodyDarkOrigin)
			COLOR = bodyDarkNew;
	}

	if(current_pixel == bandOrigin)
		COLOR = bandNew;

	if(current_pixel == buckleOrigin)
		COLOR = buckleNew;

	if(weaponTextureActive == true && (current_pixel == weaponOrigin))
		COLOR = texture(weaponTexture, scaled_uv);
	else if(current_pixel == weaponOrigin)
			COLOR = weaponNew;
	if(current_pixel == weaponSecondaryOrigin)
			COLOR = weaponSecondaryNew;
}