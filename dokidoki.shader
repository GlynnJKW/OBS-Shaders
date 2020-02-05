uniform float speed = 3;
uniform float scalex = 1.25;
uniform float scaley = 1;
uniform float red = 1;
uniform float green = 0.8;
uniform float blue = 1;

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

    dist = pow(dist, 0.5);


    float a = abs(cos(dist - ctime)); //1 + fmod(dist - ctime, 1);

    if(dist < 0.5)
    {
        float feather = 1 - dist * 2;
        feather = pow(feather, 0.3);
        a = pow(abs(cos(- ctime)), 5) * feather;
    }
    else
    {
        a = pow(a, 1000);
    }

    float4 col = float4(red, green, blue, 1);

	return a * col + (1-a) * sample;
}

