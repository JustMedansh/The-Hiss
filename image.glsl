float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;

    vec2 p = fragCoord / 20.0;
    float pattern = hash(floor(p));
    float blend = smoothstep(0.0, 1.0, fract(p.x));

    float left = hash(floor(p));
    float right = hash(floor(p) + vec2(1.0, 0.0));
    float bottom = hash(floor(p) + vec2(0.0, 1.0));
    float top = hash(floor(p) + vec2(1.0, 1.0));

    float wobble = sin(fragCoord.y * 0.03 + iTime * 2.0) * 3.0;
    // float brightness = 0.5 + 0.5 * sin(iTime + (fragCoord.x * 0.02) + wobble + sin(fragCoord.y * 0.01));
    float brightness = mix(left, right, blend, top, bottom);
    vec3 col = vec3(0.6, 0.0, 0.0) * brightness;

    fragColor = vec4(col, 1.0);
}
