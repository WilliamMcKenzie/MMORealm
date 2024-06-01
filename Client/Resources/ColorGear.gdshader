shader_type canvas_item;

uniform vec4 line_color : hint_color = vec4(0, 0, 0, 1);
uniform float line_thickness : hint_range(0, 10) = 0.4;
uniform float glow_thickness : hint_range(0, 20) = 4.0;
uniform vec4 glow_color : hint_color = vec4(0, 0, 0, 0);

uniform vec4 helmetDarkOrigin:hint_color;
uniform vec4 helmetDarkNew:hint_color;

uniform vec4 helmetLightOrigin:hint_color;
uniform vec4 helmetLightNew:hint_color;

uniform vec4 helmetMediumOrigin:hint_color;
uniform vec4 helmetMediumNew:hint_color;

uniform vec4 bodyLightOrigin:hint_color;
uniform vec4 bodyLightNew:hint_color;

uniform vec4 bodyMediumOrigin:hint_color;
uniform vec4 bodyMediumNew:hint_color;

uniform vec4 bandOrigin:hint_color;
uniform vec4 bandNew:hint_color;

uniform vec4 buckleOrigin:hint_color;
uniform vec4 buckleNew:hint_color;

uniform vec4 shouldersLightOrigin:hint_color;
uniform vec4 shouldersLightNew:hint_color;

uniform vec4 shouldersDarkOrigin:hint_color;
uniform vec4 shouldersDarkNew:hint_color;

uniform vec4 axeLightOrigin:hint_color;
uniform vec4 axeLightNew:hint_color;

uniform vec4 axeDarkOrigin:hint_color;
uniform vec4 axeDarkNew:hint_color;

uniform vec4 bladeOrigin:hint_color;
uniform vec4 bladeNew:hint_color;

uniform vec4 bowOrigin:hint_color;
uniform vec4 bowNew:hint_color;

uniform vec4 arrowLightOrigin:hint_color;
uniform vec4 arrowLightNew:hint_color;

uniform vec4 arrowDarkOrigin:hint_color;
uniform vec4 arrowDarkNew:hint_color;

uniform vec4 bladeTipOrigin:hint_color;
uniform vec4 bladeTipNew:hint_color;

uniform vec4 bladeHiltOrigin:hint_color;
uniform vec4 bladeHiltNew:hint_color;

uniform vec4 bladeSwingOrigin:hint_color;
uniform vec4 bladeSwingNew:hint_color;

uniform vec4 bowDarkOrigin:hint_color;
uniform vec4 bowDarkNew:hint_color;

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

	        // Skip outline calculation if the neighboring pixel color matches the color to be excluded
	        if (neighborColor == shouldersLightOrigin) {
	            vec2 neighborUV = UV + vec2(i * size.x, j * size.y);

	            // Check if any of the neighboring pixels are not transparent
	            vec4 upColor = texture(TEXTURE, neighborUV + vec2(0, size.y));
	            vec4 downColor = texture(TEXTURE, neighborUV + vec2(0, -size.y));
	            vec4 leftColor = texture(TEXTURE, neighborUV + vec2(-size.x, 0));
	            vec4 rightColor = texture(TEXTURE, neighborUV + vec2(size.x, 0));

	            if (upColor.a > 0.0 || downColor.a > 0.0 || leftColor.a > 0.0 || rightColor.a > 0.0) {
	                outline += 1.0; // Increase outline intensity
	            }
	        }

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

	if(current_pixel == helmetDarkOrigin)
		COLOR = helmetDarkNew;

	if(current_pixel == helmetLightOrigin)
		COLOR = helmetLightNew;

	if(current_pixel == helmetMediumOrigin)
		COLOR = helmetMediumNew;

	if(current_pixel == bodyLightOrigin)
		COLOR = bodyLightNew;

	if(current_pixel == bodyMediumOrigin)
		COLOR = bodyMediumNew;

	if(current_pixel == bandOrigin)
		COLOR = bandNew;

	if(current_pixel == buckleOrigin)
		COLOR = buckleNew;

	if(current_pixel == shouldersLightOrigin)
		COLOR = shouldersLightNew;

	if(current_pixel == shouldersDarkOrigin)
		COLOR = shouldersDarkNew;

	if(current_pixel == axeLightOrigin)
		COLOR = axeLightNew;

	if(current_pixel == axeDarkOrigin)
		COLOR = axeDarkNew;

	if(current_pixel == bladeOrigin)
		COLOR = bladeNew;

	if(current_pixel == bowOrigin)
		COLOR = bowNew;

	if(current_pixel == arrowLightOrigin)
		COLOR = arrowLightNew;

	if(current_pixel == arrowDarkOrigin)
		COLOR = arrowDarkNew;

	if(current_pixel == bladeTipOrigin)
		COLOR = bladeTipNew;

	if(current_pixel == bladeHiltOrigin)
		COLOR = bladeHiltNew;

	if(current_pixel == bladeSwingOrigin)
		COLOR = bladeSwingNew;

	if(current_pixel == bowDarkOrigin)
		COLOR = bowDarkNew;
}