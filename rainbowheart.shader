uniform float speed = 1;
uniform float saturation = 1;
uniform float luminosity = 0.5;
uniform float weight = 0.2;
uniform float multiply = 0.5;
uniform float scalex = 0.82;
uniform float scaley = 1;


float3 HUEtoRGB(in float H)
{
    float R = abs(H * 6 - 3) - 1;
    float G = 2 - abs(H * 6 - 2);
    float B = 2 - abs(H * 6 - 4);
    return saturate(float3(R,G,B));
}

float3 HSLtoRGB(in float3 HSL)
{
    float3 RGB = HUEtoRGB(HSL.x);
    float C = (1 - abs(2 * HSL.z - 1)) * HSL.y;
    return (RGB - 0.5) * C + HSL.z;
}

float4 mainImage(VertData v_in) : TARGET
{
	float4 sample = image.Sample(textureSampler, v_in.uv);

    float ctime = speed * elapsed_time;
    // float dist = length(float2(0.5,0.5) - v_in.uv);

    float2 coord = float2(v_in.uv.x*2 - 1, v_in.uv.y*2 - 1.25);
    coord.x *= uv_size.x / uv_size.y;
    coord *= float2(scalex, scaley);

    float dist = 0;
    if(coord.x < 0)
    {
        dist = 2 * coord.x * coord.x - 2 * coord.x * coord.y + coord.y * coord.y;
    }
    else
    {
        dist = 2 * coord.x * coord.x + 2 * coord.x * coord.y + coord.y * coord.y;
    }

    //float dist = abs(v_in.uv.x - 0.5) + abs(v_in.uv.y - 0.5);

    dist = sqrt(dist);

    float hue = 1 + fmod(dist - ctime, 1);
    float3 hsl = float3(hue, saturation, luminosity);
    float3 col = HSLtoRGB(hsl);

    float4 mult = sample * float4(col,1);
    float4 straight = weight * float4(col,1) + (1.0-weight) * sample;

	return multiply * mult + (1-multiply) * straight;
}

