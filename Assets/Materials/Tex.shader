Shader "Custom/Tex"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
        _Mask ("Albedo (RGBA)", 2D) = "white" {}
        _MaskRatio ("Ratio", Range(0,1)) = 0      
          
        _SubTex ("Sub Albedo (RGB)", 2D) = "white" {}
        _Ratio ("Ratio", Range(0,1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SubTex;
        sampler2D _Mask;
        float _Ratio;
        float _MaskRatio;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D (_SubTex, IN.uv_MainTex);
            fixed4 m = tex2D (_Mask, IN.uv_MainTex);
            // o.Albedo = c.rgb;
            o.Albedo = lerp(lerp(c.rgb, m.rgb, _MaskRatio * m.a), d.rgb, _Ratio);
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
