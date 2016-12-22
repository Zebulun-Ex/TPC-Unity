Shader "Shader Forge/Marble" {
    Properties {
        _MurbDif ("Murb Dif", 2D) = "white" {}
        _specpower ("spec power", Range(1, 10)) = 1
        _specintens ("spec intens", Range(0, 1)) = 0
        _MurbNormal ("Murb Normal", 2D) = "bump" {}
        _node_3602 ("node_3602", Cube) = "_Skybox" {}
        _Skyboxblur ("Skybox blur", Range(0, 7)) = 0
        _Mask ("Mask", 2D) = "white" {}
        _mask_intens ("mask_intens", Range(0, 5)) = 1
        _Mask_power ("Mask_power", Range(0, 5)) = 0
        _SkyboxExp ("Skybox Exp", Range(0, 5)) = 0
        _NormalMultiply ("Normal Multiply", Range(0, 5)) = 0
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            #pragma glsl
            uniform sampler2D _MurbDif; uniform float4 _MurbDif_ST;
            uniform float _specpower;
            uniform float _specintens;
            uniform sampler2D _MurbNormal; uniform float4 _MurbNormal_ST;
            uniform samplerCUBE _node_3602;
            uniform float _Skyboxblur;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _mask_intens;
            uniform float _Mask_power;
            uniform float _SkyboxExp;
            uniform float _NormalMultiply;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _MurbNormal_var = UnpackNormal(tex2D(_MurbNormal,TRANSFORM_TEX(i.uv0, _MurbNormal)));
                float3 node_4032 = float3(0,0,1);
                float3 normalLocal = lerp(_MurbNormal_var.rgb,node_4032,_NormalMultiply);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float4 _MurbDif_var = tex2D(_MurbDif,TRANSFORM_TEX(i.uv0, _MurbDif));
                float3 node_3925 = (_MurbDif_var.rgb*((attenuation*_LightColor0.rgb*max(0,dot(normalDirection,lightDirection)))+UNITY_LIGHTMODEL_AMBIENT.rgb+(pow(max(0,dot(lightDirection,viewReflectDirection)),exp2(_specpower))*_specintens)));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float3 finalColor = (lerp((node_3925+pow(texCUBElod(_node_3602,float4(viewReflectDirection,_Skyboxblur)).rgb,_SkyboxExp)),node_3925,saturate(pow((_Mask_var.rgb*_mask_intens),_Mask_power)))*1.0);
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            #pragma glsl
            uniform sampler2D _MurbDif; uniform float4 _MurbDif_ST;
            uniform float _specpower;
            uniform float _specintens;
            uniform sampler2D _MurbNormal; uniform float4 _MurbNormal_ST;
            uniform samplerCUBE _node_3602;
            uniform float _Skyboxblur;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _mask_intens;
            uniform float _Mask_power;
            uniform float _SkyboxExp;
            uniform float _NormalMultiply;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _MurbNormal_var = UnpackNormal(tex2D(_MurbNormal,TRANSFORM_TEX(i.uv0, _MurbNormal)));
                float3 node_4032 = float3(0,0,1);
                float3 normalLocal = lerp(_MurbNormal_var.rgb,node_4032,_NormalMultiply);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float4 _MurbDif_var = tex2D(_MurbDif,TRANSFORM_TEX(i.uv0, _MurbDif));
                float3 node_3925 = (_MurbDif_var.rgb*((attenuation*_LightColor0.rgb*max(0,dot(normalDirection,lightDirection)))+UNITY_LIGHTMODEL_AMBIENT.rgb+(pow(max(0,dot(lightDirection,viewReflectDirection)),exp2(_specpower))*_specintens)));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float3 finalColor = (lerp((node_3925+pow(texCUBElod(_node_3602,float4(viewReflectDirection,_Skyboxblur)).rgb,_SkyboxExp)),node_3925,saturate(pow((_Mask_var.rgb*_mask_intens),_Mask_power)))*1.0);
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
