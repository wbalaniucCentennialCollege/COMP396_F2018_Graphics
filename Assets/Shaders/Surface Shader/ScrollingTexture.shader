Shader "Custom/ScrollingTexture" {
	Properties {
		_MainTint ("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_ScrollXSpeed("X Scroll Speed", Range(0, 10)) = 2
		_ScrollYSpeed("Y Scroll Speed", Range(0, 10)) = 2
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		fixed4 _MainTint;
		sampler2D _MainTex;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;

		struct Input {
			float2 uv_MainTex;
		};

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input IN, inout SurfaceOutputStandard o) {
			// Create a separate variable to store out UVs before we pass them to the tex2D function
			fixed2 scrolledUV = IN.uv_MainTex;

			// Create variables that store the individual x and y components for the UVs scaled by [REDACTED]
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;

			// Apply UV offset
			scrolledUV += fixed2(xScrollValue, yScrollValue);

			// Apply texture and tint
			half4 c = tex2D(_MainTex, scrolledUV);
			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;
		}

		ENDCG
	}
}