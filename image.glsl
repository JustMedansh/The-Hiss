// Welcome! This is a Shadertoy-style shader.
// mainImage runs once for each pixel, every frame.
// Try changing a number, then watch the preview on the right.

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Pixel position, from 0 to 1 across the screen.
    vec2 uv = fragCoord / iResolution.xy;

    // A colour that shifts over time.
    // vec3 col = 0.5 + 0.5 * cos(iTime + uv.xyx + vec3(0.0, 2.0, 4.0));
    float brightness = 0.5 + 0.5 * sin(iTime + fragCoord.x * 0.02);
    vec3 col = vec3(0.6, 0.0, 0.0) * brightness;

    // A soft circle in the middle that follows the mouse while you hold a button.

    fragColor = vec4(col, 1.0);
}
