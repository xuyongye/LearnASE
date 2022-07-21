// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Rampart"
{
	Properties
	{
		_Float0("宽度", Float) = 4.18
		_Float1("深度检测宽", Float) = 0.27
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Vector0("密度与速度", Vector) = (0,0,0,0)
		_TextureSample1("渐变图", 2D) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Off
		ColorMask RGBA
		ZWrite Off
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
				float3 ase_normal : NORMAL;
				float4 ase_texcoord2 : TEXCOORD2;
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

			uniform float _Float0;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _Float1;
			uniform sampler2D _TextureSample0;
			uniform float4 _Vector0;
			uniform sampler2D _TextureSample1;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord3.xy = v.ase_texcoord2.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
				o.ase_texcoord3.zw = 0;
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
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float dotResult2 = dot( ase_worldViewDir , ase_worldNormal );
				float4 screenPos = i.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth12 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth12 = abs( ( screenDepth12 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Float1 ) );
				float temp_output_11_0 = ( pow( ( 1.0 - abs( dotResult2 ) ) , _Float0 ) + saturate( ( 1.0 - distanceDepth12 ) ) );
				float2 appendResult25 = (float2(_Vector0.x , _Vector0.y));
				float3 appendResult28 = (float3(_Vector0.z , _Vector0.w , 0.0));
				float4 color40 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				float2 texCoord57 = i.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_cast_2 = (( temp_output_11_0 + texCoord57.x )).xx;
				
				
				finalColor = ( temp_output_11_0 * tex2D( _TextureSample0, ( float3( ( (ase_screenPosNorm).xy * appendResult25 ) ,  0.0 ) + ( appendResult28 * _Time.y ) ).xy ) * ( color40 * tex2D( _TextureSample1, temp_cast_2 ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
37;90;1525;793;1188.285;-726.8947;1.079524;True;False
Node;AmplifyShaderEditor.CommentaryNode;8;-1106.267,-347.9724;Inherit;False;1108.516;434.8472;菲尼尔;5;7;5;1;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1;-1039.079,-269.166;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;3;-1056.267,-96.12519;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;18;-1110.476,210.7548;Inherit;False;1100.086;274.5656;采用深度渐变 与其他物体进行碰撞交互;4;17;13;15;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-549.6352,-288.9545;Inherit;False;200;161;去掉负数;1;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;2;-795.2621,-250.1149;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1060.476,369.3203;Inherit;False;Property;_Float1;深度检测宽;1;0;Create;False;0;0;0;False;0;False;0.27;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;4;-499.635,-238.9544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;7;-295.7503,-297.9724;Inherit;False;248;304;边缘淡中心亮取反;1;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;38;-2109.67,607.9556;Inherit;False;1399.947;900.7755;纹理;7;22;36;35;23;26;33;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;15;-588.9006,287.3049;Inherit;False;229;161;碰到的地方亮;1;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DepthFade;12;-849.2957,349.7994;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;17;-275.3889,260.7547;Inherit;False;215;161;取0~1 锁定到模型范围;1;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;22;-2059.671,657.9556;Inherit;False;513.5883;262;屏幕X Y 坐标;2;19;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-130.5575,109.9841;Inherit;False;Property;_Float0;宽度;0;0;Create;False;0;0;0;False;0;False;4.18;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;6;-245.7503,-247.9723;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-538.9005,337.3049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-500.9112,934.6597;Inherit;False;1252.817;578.2306;渐变色;4;45;40;41;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;45;-450.9112,1273.089;Inherit;False;414.6686;190.0248;可以设定渐变色UV的起点 去的 X 与 可变Y ;2;56;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;19;-2009.671,707.9556;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;16;-225.3891,310.7548;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-1792.016,1185.343;Inherit;False;460.502;323.3882;速度uv;3;29;31;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;9;129.0542,-170.2308;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;23;-1995.442,1038.509;Inherit;False;Property;_Vector0;密度与速度;3;0;Create;False;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;35;-1769.874,944.2216;Inherit;False;211;185;密度Tiling 16 : 9 = 8, 4.5;1;25;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;31;-1742.016,1397.731;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;21;-1769.082,716.1942;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-1719.874,994.2217;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-421.8234,1327.109;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;11;430.7151,193.382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1706.341,1235.343;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1489.824,942.554;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1493.515,1305.465;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-174.6325,1338.236;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;66.20509,1282.89;Inherit;True;Property;_TextureSample1;渐变图;4;0;Create;False;0;0;0;False;0;False;-1;5f57c110c89ccd542abda3719c5818ae;5f57c110c89ccd542abda3719c5818ae;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;141.8315,984.6597;Inherit;False;Constant;_Color0;Color 0;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1220.408,1049.582;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;20;-1029.725,772.784;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;0;False;0;False;-1;abb24727399ff0840aea198a236353b4;abb24727399ff0840aea198a236353b4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;55;-489.2578,1552.941;Inherit;False;837.7961;492.6473;渐变图采样;4;50;53;47;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;589.9059,1070.012;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;54;-404.6134,1883.402;Inherit;False;Constant;_Vector1;Vector 1;7;0;Create;True;0;0;0;False;0;False;4.09,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;666.43,387.0732;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;50;28.53812,1690.382;Inherit;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;5f57c110c89ccd542abda3719c5818ae;5f57c110c89ccd542abda3719c5818ae;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-138.5384,1768.608;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-439.2578,1602.941;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;976.6704,624.8266;Float;False;True;-1;2;ASEMaterialInspector;100;1;Rampart;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;4;0;2;0
WireConnection;12;0;13;0
WireConnection;6;0;4;0
WireConnection;14;0;12;0
WireConnection;16;0;14;0
WireConnection;9;0;6;0
WireConnection;9;1;10;0
WireConnection;21;0;19;0
WireConnection;25;0;23;1
WireConnection;25;1;23;2
WireConnection;11;0;9;0
WireConnection;11;1;16;0
WireConnection;28;0;23;3
WireConnection;28;1;23;4
WireConnection;26;0;21;0
WireConnection;26;1;25;0
WireConnection;29;0;28;0
WireConnection;29;1;31;0
WireConnection;56;0;11;0
WireConnection;56;1;57;1
WireConnection;42;1;56;0
WireConnection;33;0;26;0
WireConnection;33;1;29;0
WireConnection;20;1;33;0
WireConnection;41;0;40;0
WireConnection;41;1;42;0
WireConnection;37;0;11;0
WireConnection;37;1;20;0
WireConnection;37;2;41;0
WireConnection;50;1;53;0
WireConnection;53;0;47;0
WireConnection;53;1;54;0
WireConnection;0;0;37;0
ASEEND*/
//CHKSM=6AF2E167BE9610015B70E7D0A35E52B988AB43D7