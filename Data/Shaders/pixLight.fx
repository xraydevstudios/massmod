//�������� ALPHATEST � �������
//#define ALPHATEST

#define DIFF_TEX 1
#define NORMAL 1
#define FOG_ENABLE

#include "lighting.fx"

texture diffTex;

sampler2D diffMap: register(s0) = sampler_state
{
	Texture = diffTex;
};




float4 PixLightSpotPS(ModelPSIn modelIn): COLOR
{
    //�.�. ����� �������� ������ ��� �� ������������, 
    //�� ���������� ������ �� ������� � ������� �� ��������
    //������������ ����� ����� � �������
#ifdef ALPHATEST
    if (tex2D(diffMap, modelIn.diffTex).a < 0.5f)
       discard;
#endif

    ModelPSOut modelOut;
    CompModelPSOut(modelIn, modelOut);

    float4 texColor = tex2D(diffMap, modelIn.diffTex);
    float3 light = CompSpotLight(modelOut, texColor.rgb);

    return float4(light, texColor.a);
}




technique techPixLightSpot
{
    pass p0
    {

//���������� �������� ����� �����
#ifdef ALPHATEST
       AlphaTestEnable = false;
#endif

       //FogColor = 0x000000;

       VertexShader = compile vs_3_0 ModelVS();
       PixelShader = compile ps_3_0 PixLightSpotPS();
    }
}