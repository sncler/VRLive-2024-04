Shader "Custom/WaterFall"
{
    Properties
    {
        _DistortionTex("Distortion Texture(RG)", 2D) = "grey" {}
        _DistortionPower("Distortion Power", Range(0, 1)) = 0
        _Speed("Scroll Speed", Range(0, 1)) = 0
        _FoamTex("Foam Texture", 2D) = "white" {}
        _FoamTex2("Foam Texture 2", 2D) = "white" {}
        _FoamColor("Foam Color", Color) = (0,0,0,0)
        _FoamColor2("Foam Color2", Color) = (0,0,0,0)
        [HDR] _EmissionColor("Emission Color", Color) = (1,1,1,1)
        _EmissionPower("Emission Power", Range(0, 3)) = 2

    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType" = "Transparent" }

        Cull off
        //ZWrite On
        //ZTest LEqual
        //ColorMask RGB

        GrabPass { "_GrabTexture" }

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _DistortionTex;
        sampler2D _GrabTexture;
        float _DistortionPower;
        float _Speed;
        sampler2D _FoamTex;
        float4 _FoamTex_ST;
        sampler2D _FoamTex2;
        float4 _FoamTex2_ST;
        half4 _FoamColor;
        half4 _FoamColor2;
        half4 _EmissionColor;
        half _EmissionPower;

        struct Input
        {
            float2 uv_DistortionTex;
            float4 screenPos;
        };



        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        // UNITY_INSTANCING_BUFFER_START(Props)
        //     // put more per-instance properties here
        // UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            half2 grabUV = (IN.screenPos.xy / IN .screenPos.w);

            //UVスクロール
            IN.uv_DistortionTex.y += _Time.y * _Speed;

            //ノーマルマップ
            fixed2 distortionTex = UnpackNormal(tex2D(_DistortionTex, IN.uv_DistortionTex)).rg;
            
            //ノーマルマップ分ずらす
            grabUV += distortionTex * _DistortionPower *0.1;
            fixed3 grab = tex2D(_GrabTexture, grabUV).rgb;

            fixed4 p  = tex2D (_FoamTex, IN.uv_DistortionTex * _FoamTex_ST);
            fixed4 p2  = tex2D (_FoamTex2, IN.uv_DistortionTex * _FoamTex2_ST);
            

            
            o.Emission = lerp(lerp(grab , _FoamColor, p), _FoamColor2, p2)*_EmissionColor*_EmissionPower;
            o.Albedo = lerp(lerp(grab , _FoamColor, p), _FoamColor2, p2);//fixed4(0, 0, 0, 0);
        }
        ENDCG
    }
    FallBack "Diffuse"
    // Properties {

	// }

	// SubShader {
	// 	Tags {
	// 		"Queue"      = "Transparent"
	// 		"RenderType" = "Transparent"
	// 	}

	// 	GrabPass {}
		
	// 	CGPROGRAM
	// 		#pragma target 3.0
	// 		#pragma surface surf Standard fullforwardshadows

	// 		sampler2D _GrabTexture;

	// 		struct Input {
	// 			float4 screenPos;
	// 		};

	// 		void surf (Input IN, inout SurfaceOutputStandard o) {
	// 			float2 grabUV = (IN.screenPos.xy / IN.screenPos.w);
    //             grabUV.y = grabUV.y  - 0.1;
	// 			fixed3 grab = tex2D(_GrabTexture, grabUV).rgb;

	// 			o.Emission = grab;
	// 			o.Albedo   = fixed3(0, 0, 0);
	// 		}
	// 	ENDCG
	// }

	// FallBack "Transparent/Diffuse"
}
