uniform float speed;

float4 mainImage(VertData v_in) : TARGET
{
	float4 color = image.Sample(textureSampler, v_in.uv);
	float t = elapsed_time * speed;
    float sint = (1 + sin(t)) / 2;
	return color * float4(1 + sint, sint, sint, 1);
}
