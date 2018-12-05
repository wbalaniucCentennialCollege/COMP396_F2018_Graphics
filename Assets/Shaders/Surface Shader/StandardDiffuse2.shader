Shader "Custom/StandardDiffuse2" {
	Properties {
		_Color("Colour", Color) = (1,1,1,1)
		_AmbientColor("Ambient Colour", Color) = (1,1,1,1)
		_MySliderValue("This is a slider", Range(0, 10)) = 2.5
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		float4 _AmbientColor;
		float _MySliderValue;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		// The "SurfaceOutput" (Unity 4) it has the follow properties:
		/*
			fixed3 Albedo - Diffuse colour of the material
			fixed3 Normal - Tangent-space normal, if written
			fixed3 Emission - The colour of the light emitted by the material
			fixed Alpha - Transparency
			half Specular - Specular power (reflectivness) from 0 to 1
			fixed Gloss - Specular intensity
		*/
		// The "SurfaceOutputStandard" (Unity 5+) struct has the following properties
		/*
			fixed3 Albedo
			fixed3 Normal
			half3 Emission
			fixed Alpha
			half Occclusion - Default to 1
			half Smoothness - 0 = rough, 1 = smooth
			half Metallic - 0 = non-metal, 1 = metal
		*/
		// The "SurfaceOutputStandardSpecular" struct has the following properties
		/*
			fixed3 Albedo
			fixed3 Normal
			half3 Emission
			fixed Alpha
			half Occlusion
			half Smoothness
			fixed3 Specular - Specular color. Actual colour of the specularity
		*/
		// "SWIZZLING" _Color.rgb == _Color.xyz
		// "SMEARING" is o.Albedo = 0; // BLACK = (0,0,0)
		// "MASKING" o.Albedo.rg = _Color.rg

		void surf(Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = pow((_Color + _AmbientColor), _MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	}
}