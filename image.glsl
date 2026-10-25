// Welcome! This is a Shadertoy-style shader.
// mainImage runs once for each pixel, every frame.
// Try changing a number, then watch the preview on the right.


float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;

    vec2 p = fragCoord / 20.0;
    float pattern = hash(floor(p));
    float blend = smoothstep(0.0, 1.0, fract(p.x));
    float wobble = sin(fragCoord.y * 0.03 + iTime * 2.0) * 3.0;
    // float brightness = 0.5 + 0.5 * sin(iTime + (fragCoord.x * 0.02) + wobble + sin(fragCoord.y * 0.01));
    float brightness = pattern;
    vec3 col = vec3(0.6, 0.0, 0.0) * brightness;

    fragColor = vec4(col, 1.0);
}
