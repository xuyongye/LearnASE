// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "mianju"
{
	Properties
	{
		_MainTex("主纹理", 2D) = "white" {}
		[HDR]_Color0("边缘光颜色", Color) = (0,0.8542314,1,0)
		_Vector0("菲尼尔参数", Vector) = (-0.35,1.68,3.5,0)
		_TextureSample0("背面图", 2D) = "white" {}
		_Vector1("主纹理Tiling倍率", Vector) = (1,1,0,0)
		_Vector3("叠加纹理Tiling倍率", Vector) = (1,1,0,0)
		_Vector5("扰动叠加纹理Tiling倍率", Vector) = (0.29,0.39,0,0)
		_Vector2("主纹理uv速度", Vector) = (0.1,0.1,0,0)
		_Vector4("叠加纹理uv速度", Vector) = (0.16,0.13,0,0)
		_Vector6("扰动叠加纹理uv速度", Vector) = (0.1,-0.1,0,0)
		_TextureSample1("叠加纹理", 2D) = "white" {}
		_TextureSample2("扰动图", 2D) = "white" {}
		_Float0("扰动强度", Float) = 0.21
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float3 _Vector0;
			uniform float4 _Color0;
			uniform sampler2D _TextureSample0;
			uniform float2 _Vector2;
			uniform float2 _Vector1;
			uniform sampler2D _TextureSample1;
			uniform float2 _Vector4;
			uniform float2 _Vector3;
			uniform sampler2D _TextureSample2;
			uniform float2 _Vector6;
			uniform float2 _Vector5;
			uniform float _Float0;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i , half ase_vface : VFACE) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float fresnelNdotV3 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode3 = ( _Vector0.x + _Vector0.y * pow( 1.0 - fresnelNdotV3, _Vector0.z ) );
				float4 screenPos = i.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_output_13_0 = (ase_screenPosNorm).xy;
				float2 panner14 = ( 1.0 * _Time.y * _Vector2 + ( temp_output_13_0 * _Vector1 ));
				float2 panner19 = ( 1.0 * _Time.y * _Vector4 + ( temp_output_13_0 * _Vector3 ));
				float2 panner23 = ( 1.0 * _Time.y * _Vector6 + ( temp_output_13_0 * _Vector5 ));
				float2 temp_cast_0 = (tex2D( _TextureSample2, panner23 ).r).xx;
				float2 lerpResult28 = lerp( panner19 , temp_cast_0 , _Float0);
				float4 color31 = IsGammaSpace() ? float4(0,0.4638824,1,0) : float4(0,0.1821208,1,0);
				float4 switchResult1 = (((ase_vface>0)?(( tex2D( _MainTex, uv_MainTex ) + ( saturate( fresnelNode3 ) * _Color0 ) )):(( tex2D( _TextureSample0, panner14 ) + ( tex2D( _TextureSample1, lerpResult28 ) * color31 ) ))));
				
				
				finalColor = switchResult1;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
-1798;196;1400;671;562.7213;16.4649;1;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;12;-2710.741,277.9856;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;24;-2369.24,1385.964;Inherit;False;Property;_Vector5;扰动叠加纹理Tiling倍率;6;0;Create;False;0;0;0;False;0;False;0.29,0.39;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;13;-2459.172,286.2332;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;20;-2355.816,855.9221;Inherit;False;Property;_Vector3;叠加纹理Tiling倍率;5;0;Create;False;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;25;-2352.24,1530.964;Inherit;False;Property;_Vector6;扰动叠加纹理uv速度;9;0;Create;False;0;0;0;False;0;False;0.1,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-2045.73,1395.2;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;23;-1862.248,1409.195;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;21;-2338.816,984.9223;Inherit;False;Property;_Vector4;叠加纹理uv速度;8;0;Create;False;0;0;0;False;0;False;0.16,0.13;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2008.149,823.2751;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;4;-1994.622,-317.0154;Inherit;False;Property;_Vector0;菲尼尔参数;2;0;Create;False;0;0;0;False;0;False;-0.35,1.68,3.5;-0.35,1.68,3.5;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-1448.996,1044.967;Inherit;False;Property;_Float0;扰动强度;12;0;Create;False;0;0;0;False;0;False;0.21;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;19;-1824.667,837.2703;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;15;-2127.151,429.1869;Inherit;False;Property;_Vector1;主纹理Tiling倍率;4;0;Create;False;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;27;-1533.86,1325.022;Inherit;True;Property;_TextureSample2;扰动图;11;0;Create;False;0;0;0;False;0;False;-1;21e1fd9fed8d3c44d9d644cfb401dd8a;21e1fd9fed8d3c44d9d644cfb401dd8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;3;-1773.036,-331.6223;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;-1048.918,831.5943;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;17;-2111.876,565.0887;Inherit;False;Property;_Vector2;主纹理uv速度;7;0;Create;False;0;0;0;False;0;False;0.1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1874.386,403.4418;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;31;-703.3989,1080.126;Inherit;False;Constant;_Color1;Color 1;13;1;[HDR];Create;True;0;0;0;False;0;False;0,0.4638824,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-748.256,808.5604;Inherit;True;Property;_TextureSample1;叠加纹理;10;0;Create;False;0;0;0;False;0;False;-1;6f9807f5763a68344b69843220290f52;6f9807f5763a68344b69843220290f52;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-1700.115,-71.70286;Inherit;False;Property;_Color0;边缘光颜色;1;1;[HDR];Create;False;0;0;0;False;0;False;0,0.8542314,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;14;-1690.902,417.437;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;6;-1439.357,-311.2355;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1228.624,-252.1388;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1737.904,-568.4824;Inherit;True;Property;_MainTex;主纹理;0;0;Create;False;0;0;0;False;0;False;-1;2c6536772776dd84f872779990273bfc;2c6536772776dd84f872779990273bfc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-230.5813,931.0071;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;11;-767.4772,381.8904;Inherit;True;Property;_TextureSample0;背面图;3;0;Create;False;0;0;0;False;0;False;-1;e9877d53304af9246ab494db27103a47;e9877d53304af9246ab494db27103a47;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-759.6599,-202.628;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-55.18616,436.1992;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;1;517.3161,102.276;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;788.5508,83.75604;Float;False;True;-1;2;ASEMaterialInspector;100;1;mianju;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;13;0;12;0
WireConnection;22;0;13;0
WireConnection;22;1;24;0
WireConnection;23;0;22;0
WireConnection;23;2;25;0
WireConnection;18;0;13;0
WireConnection;18;1;20;0
WireConnection;19;0;18;0
WireConnection;19;2;21;0
WireConnection;27;1;23;0
WireConnection;3;1;4;1
WireConnection;3;2;4;2
WireConnection;3;3;4;3
WireConnection;28;0;19;0
WireConnection;28;1;27;1
WireConnection;28;2;29;0
WireConnection;16;0;13;0
WireConnection;16;1;15;0
WireConnection;26;1;28;0
WireConnection;14;0;16;0
WireConnection;14;2;17;0
WireConnection;6;0;3;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;30;0;26;0
WireConnection;30;1;31;0
WireConnection;11;1;14;0
WireConnection;10;0;2;0
WireConnection;10;1;8;0
WireConnection;32;0;11;0
WireConnection;32;1;30;0
WireConnection;1;0;10;0
WireConnection;1;1;32;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=2A4769C60E7CD66EC390E9A622722FAB59A1A384