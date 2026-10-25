#define PI 3.14159265

float hash(vec2 p)
{
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);

    f = f * f * (3.0 - 2.0 * f);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    return mix(
        mix(a, b, f.x),
        mix(c, d, f.x),
        f.y
    );
}

float fbm(vec2 p)
{
    float value = 0.0;
    float amplitude = 0.5;

    for (int i = 0; i < 5; i++)
    {
        value += amplitude * noise(p);
        p = p * 2.0 + vec2(17.13, 9.27);
        amplitude *= 0.5;
    }

    return value;
}


void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;
    float t = iTime;

    vec2 flow = vec2(
        fbm(uv * 2.0 + vec2(t * 0.12, 0.0)),
        fbm(uv * 2.0 + vec2(5.2, -t * 0.10))
    );

    vec2 q = uv + (flow - 0.5) * 0.65;

    float clouds = fbm(q * 4.0 + vec2(t * 0.08, -t * 0.16));
    float detail = fbm(q * 10.0 - vec2(t * 0.22, t * 0.12));
    float fineDetail = noise(q * 25.0 + vec2(-t * 0.3, t * 0.2));

    float field = clouds * 0.65 + detail * 0.28 + fineDetail * 0.07;
    float filaments = 1.0 - smoothstep(0.025, 0.22, abs(field - 0.52));

    float mass = smoothstep(0.30, 0.68, field);
    float wisps = smoothstep(0.40, 0.73, field + filaments * 0.35);

    float streaks = 0.5 + 0.5 * sin(
        q.y * 32.0 + q.x * 9.0 + flow.x * 12.0 - t * 1.4
    );

    vec3 darkRed = vec3(0.035, 0.001, 0.004);
    vec3 deepRed = vec3(0.30, 0.004, 0.015);
    vec3 hotRed  = vec3(0.95, 0.025, 0.045);
    vec3 glowRed = vec3(1.0, 0.16, 0.12);

    vec3 col = mix(darkRed, deepRed, mass);
    col = mix(col, hotRed, wisps * 0.65);
    col += glowRed * filaments * streaks * 0.45;

    float vignette = 1.0 - smoothstep(0.35, 0.85, length(uv));
    col *= 0.45 + vignette * 0.55;

    col *= 0.92 + 0.08 * sin(t * 1.7 + flow.x * 4.0);

    fragColor = vec4(col, 1.0);
}