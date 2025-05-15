Shader "Unlit/UnlitScript"
{
    Properties
    {
        _MainTex1 ("Texture 1", 2D) = "white" {}
        _MainTex2 ("Texture 2", 2D) = "white" {}
        
        _Blend ("Texture blend", Range(0, 1)) = .5
        
        _PlayerPosition ("Player Position", Vector) = (0, 0, 0, 0)
        _PlayerDistance ("Player Distance", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 offset : TEXCOORD1;
                float4 worldPos : TEXCOORD2;
            };

            sampler2D _MainTex1;
            float4 _MainTex1_ST;
            sampler2D _MainTex2;
            float4 MainText2_ST;

            float _Blend;

            float4 _PlayerPosition;
            float _PlayerDistance;

            v2f vert (appdata v)
            {
                v2f o;

                o.worldPos = mul(unity_ObjectToWorld, v.vertex);

                float3 diff = o.worldPos - _PlayerPosition;
                o.worldPos.xyz -= diff * (1 - saturate(dot(v.normal, normalize(diff))));

                v.vertex = mul(unity_WorldToObject, o.worldPos);
                
                o.offset = float4(0, 0, 0, 0);
                v.vertex.xyz += o.offset.xyz;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex1);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;

                // o.offset = float4(
                //     0,
                //     sin(_Time.x * 100 + v.vertex.z * 10 / _PlayerDistance) * 0.1,
                //     0,
                //     0
                // );
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col1 = tex2D(_MainTex1, i.uv);
                fixed4 col2 = tex2D(_MainTex2, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col1);
                //return fixed4(1, sin(_Time.x * 100), 0, 0);
                return lerp(col1, col2, 0.1 + i.offset.y);
            }
            ENDCG
        }
    }
}
