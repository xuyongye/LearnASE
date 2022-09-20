// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "24"
{
	Properties
	{
		_Genshin_WGS_WGS_Bottom_BaseColortga("Genshin_WGS_WGS_Bottom_BaseColor.tga", 2D) = "white" {}
		_Genshin_WGS_WGS_Bottom_Emissivetga("Genshin_WGS_WGS_Bottom_Emissive.tga", 2D) = "white" {}
		_Genshin_WGS_WGS_Bottom_Metallictga("Genshin_WGS_WGS_Bottom_Metallic.tga", 2D) = "white" {}
		_Genshin_WGS_WGS_Bottom_Normaltga("Genshin_WGS_WGS_Bottom_Normal.tga", 2D) = "bump" {}
		[HDR]_Color0("发光颜色", Color) = (0,0,0,0)
		_Float0("光边进程", Range( -1 , 0)) = -0.08671696
		[HDR]_Color1("光边颜色", Color) = (0.8207547,0,0,0)
		_Eff_WeaponsTotem_Grain_00("Eff_WeaponsTotem_Grain_00", 2D) = "white" {}
		[HDR]_Color2("纹理颜色", Color) = (0,0.2462554,1,1)
		_Float3("纹理强度", Range( 0 , 2)) = 1.634413
		_Float6("纹理强度2", Range( 0 , 2)) = 1.634413
		_185416m37gmnk9ib6u7gkg("185416m37gmnk9ib6u7gkg", 2D) = "white" {}
		_Float4("溶解进程", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _Genshin_WGS_WGS_Bottom_Normaltga;
		uniform float4 _Genshin_WGS_WGS_Bottom_Normaltga_ST;
		uniform sampler2D _Genshin_WGS_WGS_Bottom_BaseColortga;
		uniform float4 _Genshin_WGS_WGS_Bottom_BaseColortga_ST;
		uniform sampler2D _Genshin_WGS_WGS_Bottom_Emissivetga;
		uniform float4 _Genshin_WGS_WGS_Bottom_Emissivetga_ST;
		uniform float4 _Color0;
		uniform float _Float0;
		uniform float4 _Color1;
		uniform sampler2D _Eff_WeaponsTotem_Grain_00;
		uniform float4 _Eff_WeaponsTotem_Grain_00_ST;
		uniform float4 _Color2;
		uniform float _Float3;
		uniform float _Float6;
		uniform float _Float4;
		uniform sampler2D _185416m37gmnk9ib6u7gkg;
		uniform float4 _185416m37gmnk9ib6u7gkg_ST;
		uniform sampler2D _Genshin_WGS_WGS_Bottom_Metallictga;
		uniform float4 _Genshin_WGS_WGS_Bottom_Metallictga_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Genshin_WGS_WGS_Bottom_Normaltga = i.uv_texcoord * _Genshin_WGS_WGS_Bottom_Normaltga_ST.xy + _Genshin_WGS_WGS_Bottom_Normaltga_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Genshin_WGS_WGS_Bottom_Normaltga, uv_Genshin_WGS_WGS_Bottom_Normaltga ) );
			float2 uv_Genshin_WGS_WGS_Bottom_BaseColortga = i.uv_texcoord * _Genshin_WGS_WGS_Bottom_BaseColortga_ST.xy + _Genshin_WGS_WGS_Bottom_BaseColortga_ST.zw;
			o.Albedo = tex2D( _Genshin_WGS_WGS_Bottom_BaseColortga, uv_Genshin_WGS_WGS_Bottom_BaseColortga ).rgb;
			float2 uv_Genshin_WGS_WGS_Bottom_Emissivetga = i.uv_texcoord * _Genshin_WGS_WGS_Bottom_Emissivetga_ST.xy + _Genshin_WGS_WGS_Bottom_Emissivetga_ST.zw;
			float temp_output_9_0 = ( i.uv2_texcoord2.y + _Float0 );
			float temp_output_15_0 = ( 1.0 - step( temp_output_9_0 , 0.5 ) );
			float2 uv2_Eff_WeaponsTotem_Grain_00 = i.uv2_texcoord2 * _Eff_WeaponsTotem_Grain_00_ST.xy + _Eff_WeaponsTotem_Grain_00_ST.zw;
			float2 uv_185416m37gmnk9ib6u7gkg = i.uv_texcoord * _185416m37gmnk9ib6u7gkg_ST.xy + _185416m37gmnk9ib6u7gkg_ST.zw;
			float4 tex2DNode29 = tex2D( _185416m37gmnk9ib6u7gkg, uv_185416m37gmnk9ib6u7gkg );
			float temp_output_38_0 = step( _Float4 , ( tex2DNode29.r + 0.1 ) );
			o.Emission = ( ( tex2D( _Genshin_WGS_WGS_Bottom_Emissivetga, uv_Genshin_WGS_WGS_Bottom_Emissivetga ) * _Color0 ) + ( ( temp_output_15_0 - ( 1.0 - step( temp_output_9_0 , 0.51 ) ) ) * _Color1 ) + ( ( tex2D( _Eff_WeaponsTotem_Grain_00, uv2_Eff_WeaponsTotem_Grain_00 ).r * _Color2 * _Float3 ) * _Float6 ) + ( _Color1 * ( temp_output_38_0 - step( _Float4 , tex2DNode29.r ) ) ) ).rgb;
			float2 uv_Genshin_WGS_WGS_Bottom_Metallictga = i.uv_texcoord * _Genshin_WGS_WGS_Bottom_Metallictga_ST.xy + _Genshin_WGS_WGS_Bottom_Metallictga_ST.zw;
			float4 tex2DNode3 = tex2D( _Genshin_WGS_WGS_Bottom_Metallictga, uv_Genshin_WGS_WGS_Bottom_Metallictga );
			o.Metallic = tex2DNode3.r;
			o.Smoothness = tex2DNode3.r;
			o.Alpha = saturate( ( saturate( temp_output_15_0 ) * temp_output_38_0 ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
-1777;746;1601;890;2087.146;-1412.59;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;21;-2982.257,498.9221;Inherit;False;2002.686;917.576;出现光边;12;7;8;12;14;9;11;13;16;15;17;19;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1810.026,2141.047;Inherit;False;1186.383;725.896;光边溶解;7;29;33;32;36;35;34;38;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2932.256,716.6627;Inherit;False;Property;_Float0;光边进程;6;0;Create;False;0;0;0;False;0;False;-0.08671696;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-2922.378,548.9221;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;27;-1935.519,1467.012;Inherit;False;1042.768;587.0792;纹理;6;22;26;24;23;25;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;29;-1791.805,2312.435;Inherit;True;Property;_185416m37gmnk9ib6u7gkg;185416m37gmnk9ib6u7gkg;11;0;Create;True;0;0;0;False;0;False;-1;a162a71e9c580594a9708d2c26fd049b;a162a71e9c580594a9708d2c26fd049b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1685.896,2537.147;Inherit;False;Constant;_Float5;Float 5;13;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2493.154,939.7228;Inherit;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;0;False;0;False;0.51;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-2570.276,635.0342;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2268.296,699.0357;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1885.519,1538.941;Inherit;False;1;23;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1448.635,2514.844;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1754.66,2191.047;Inherit;False;Property;_Float4;溶解进程;12;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;13;-2288.977,846.4866;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;11;-2057.432,608.2437;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-1615.523,1517.012;Inherit;True;Property;_Eff_WeaponsTotem_Grain_00;Eff_WeaponsTotem_Grain_00;8;0;Create;True;0;0;0;False;0;False;-1;9800e22a7c5bf554d9bc308fb15c66f7;9800e22a7c5bf554d9bc308fb15c66f7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;38;-1161.929,2484.477;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-1525.061,1713.013;Inherit;False;Property;_Color2;纹理颜色;9;1;[HDR];Create;False;0;0;0;False;0;False;0,0.2462554,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;16;-2020.435,914.4196;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;15;-1808.025,647.7916;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1603.635,1924.274;Inherit;False;Property;_Float3;纹理强度;10;0;Create;False;0;0;0;False;0;False;1.634413;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;32;-1295.591,2213.563;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1213.035,1605.787;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;-841.743,2442.257;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-1592.84,1204.498;Inherit;False;Property;_Color1;光边颜色;7;1;[HDR];Create;False;0;0;0;False;0;False;0.8207547,0,0,0;0.8207547,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-1053.609,124.6209;Inherit;False;Property;_Color0;发光颜色;5;1;[HDR];Create;False;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;-1558.178,813.6548;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;41;-658.1512,1241.411;Inherit;False;212;185;与光边的颜色相同;1;39;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;42;-437.2227,674.7018;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1140.743,-86.76021;Inherit;True;Property;_Genshin_WGS_WGS_Bottom_Emissivetga;Genshin_WGS_WGS_Bottom_Emissive.tga;2;0;Create;True;0;0;0;False;0;False;-1;42e45d2e86da0254db16a72e119829b0;42e45d2e86da0254db16a72e119829b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;48;-1283.014,1918.663;Inherit;False;Property;_Float6;纹理强度2;10;0;Create;False;0;0;0;False;0;False;1.634413;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-952.2888,1863.102;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-114.407,804.4417;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-684.0946,-28.67094;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-608.1512,1291.411;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1141.571,996.3695;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-188.4122,61.96286;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;45;114.0069,806.681;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-304.8991,-524.0452;Inherit;True;Property;_Genshin_WGS_WGS_Bottom_BaseColortga;Genshin_WGS_WGS_Bottom_BaseColor.tga;1;0;Create;True;0;0;0;False;0;False;-1;d3dcb403dab0eac43adf72a8001079ca;d3dcb403dab0eac43adf72a8001079ca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-306.5129,-325.5728;Inherit;True;Property;_Genshin_WGS_WGS_Bottom_Normaltga;Genshin_WGS_WGS_Bottom_Normal.tga;4;0;Create;True;0;0;0;False;0;False;-1;acb4244d77de06449b9189d5dc6aae62;acb4244d77de06449b9189d5dc6aae62;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;8.760121,272.0858;Inherit;True;Property;_Genshin_WGS_WGS_Bottom_Metallictga;Genshin_WGS_WGS_Bottom_Metallic.tga;3;0;Create;True;0;0;0;False;0;False;-1;73c2a93e42ef37c4d8c9e479490e6d59;73c2a93e42ef37c4d8c9e479490e6d59;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;473.0645,-135.3434;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;24;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;7;2
WireConnection;9;1;8;0
WireConnection;34;0;29;1
WireConnection;34;1;35;0
WireConnection;13;0;9;0
WireConnection;13;1;14;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;23;1;22;0
WireConnection;38;0;33;0
WireConnection;38;1;34;0
WireConnection;16;0;13;0
WireConnection;15;0;11;0
WireConnection;32;0;33;0
WireConnection;32;1;29;1
WireConnection;25;0;23;1
WireConnection;25;1;24;0
WireConnection;25;2;26;0
WireConnection;36;0;38;0
WireConnection;36;1;32;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;42;0;15;0
WireConnection;46;0;25;0
WireConnection;46;1;48;0
WireConnection;44;0;42;0
WireConnection;44;1;38;0
WireConnection;5;0;2;0
WireConnection;5;1;6;0
WireConnection;39;0;19;0
WireConnection;39;1;36;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;20;0;5;0
WireConnection;20;1;18;0
WireConnection;20;2;46;0
WireConnection;20;3;39;0
WireConnection;45;0;44;0
WireConnection;0;0;1;0
WireConnection;0;1;4;0
WireConnection;0;2;20;0
WireConnection;0;3;3;0
WireConnection;0;4;3;0
WireConnection;0;9;45;0
ASEEND*/
//CHKSM=C3997C1482172EFB3CD8B88E2F8B5D6B6D9DD7E8