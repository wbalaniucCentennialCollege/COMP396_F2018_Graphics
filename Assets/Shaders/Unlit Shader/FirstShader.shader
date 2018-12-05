// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// SHADERLAB AREA STARTS HERE
Shader "Custom/My First Shader" {
    Properties {
        _MainTexture("Main Color (RGB)", 2D) = "white" {}
        // V-name       "Alias           Type    Default"
        _Color("Colour", Color) = (1,1,1,1)

        _DissolveTexture("Dissolve Teture", 2D) = "white" {}
        _DissolveAmount("Dissolve Amount", Range(0, 1)) = 1

        // Extrude verticies declaration.
        _ExtrudeAmount("Extrude Amount", Range(-0.5, 0.5)) = 0
    }
    // You can have multiple subshaders. It will select the best one for your device.
    SubShader {
        // Take some data and draw it to the screen.
        Pass {
// SHADERLAB AREA ENDS HERE
            CGPROGRAM
            // DEFINE THE NAME OF THE VERTEX AND FRAGMENT SHADERS   
            #pragma vertex vert // Directive - "Type of shader" - Name of shader function
            #pragma fragment frag 

            // Helper functions to help with calculations
            #include "UnityCG.cginc"

            // Define the info that comes into our shader for CG
            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                // Grab normals to know the vectors point outwards from the object
                float3 normal : NORMAL;
            };

            struct v2f {
                float4 position : SV_POSITION; // SV is there to satisfy DirectX requirement
                float2 uv : TEXCOORD0;
            };

            // Variable declaration of the properties above in Shaderlab
            float4 _Color;
            sampler2D _MainTexture;

            sampler2D _DissolveTexture;
            float _DissolveAmount;

            float _ExtrudeAmount;

            // Declare our Vertex shader (soon......)
            // """"Return type""""" "vert"(DataPassIn variable)
            // VERTEXT SHADER //
            // Build the object
            v2f vert(appdata IN)  {
                v2f OUT; // Variable called "OUT" of type v2f

                // Manipulate my vertex before colour it.
                // IN.vertex.xyz += IN.normal.xyz * _ExtrudeAmount;


                // _Time is a float4 (x = t/20, y = t, z = t*2, w = t*3)
                IN.vertex.xyz += IN.normal.xyz * _ExtrudeAmount * sin(_Time.z);
                
                // Order matters
                OUT.position = UnityObjectToClipPos(IN.vertex);
                OUT.uv = IN.uv;

                return OUT;
            }

            // FRAGMENT SHADER // 
            // Colouring our object
            fixed4 frag(v2f IN) : SV_Target { // Output of this function will go to the screen for rendering
                float4 textureColour = tex2D(_MainTexture, IN.uv);

                // Dissolve code
                float4 dissolveColor = tex2D(_DissolveTexture, IN.uv);
                clip(dissolveColor.rgb - _DissolveAmount); // "Kill" the pixel at dissolveColor

                return textureColour * _Color;
            }

            // void MyFunction(int x);
            ENDCG
        }
    }
}