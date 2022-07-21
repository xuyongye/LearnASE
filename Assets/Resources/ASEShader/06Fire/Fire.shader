// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fire"
{
	Properties
	{
		_NoiseScale("噪点大小", Float) = 5
		_NoiseScale1("噪点大小2", Float) = 3.11
		_Vector0("V速度1", Vector) = (0,-1,0,0)
		_Vector1("V速度2", Vector) = (0,-0.5,0,0)
		_Vector2("V速度3", Vector) = (0,-0.23,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		_Float1("强度", Float) = 1.07

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
		Cull Back
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


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainTex;
			uniform float _Float1;
			uniform float _NoiseScale;
			uniform float2 _Vector0;
			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform float _NoiseScale1;
			uniform float2 _Vector1;
			uniform float2 _Vector2;
			uniform float4 _MainTex_ST;
					float2 voronoihash2( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi2( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash2( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						return F1;
					}
			
					float2 voronoihash13( float2 p )
					{
						
						p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
						return frac( sin( p ) *43758.5453);
					}
			
					float voronoi13( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
					{
						float2 n = floor( v );
						float2 f = frac( v );
						float F1 = 8.0;
						float F2 = 8.0; float2 mg = 0;
						for ( int j = -1; j <= 1; j++ )
						{
							for ( int i = -1; i <= 1; i++ )
						 	{
						 		float2 g = float2( i, j );
						 		float2 o = voronoihash13( n + g );
								o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
								float d = 0.5 * dot( r, r );
						 		if( d<F1 ) {
						 			F2 = F1;
						 			F1 = d; mg = g; mr = r; id = o;
						 		} else if( d<F2 ) {
						 			F2 = d;
						 		}
						 	}
						}
						return F1;
					}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float time2 = _Time.y;
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float2 panner7 = ( 1.0 * _Time.y * _Vector0 + uv_TextureSample0);
				float2 coords2 = panner7 * _NoiseScale;
				float2 id2 = 0;
				float2 uv2 = 0;
				float voroi2 = voronoi2( coords2, time2, id2, uv2, 0 );
				float time13 = _Time.y;
				float2 panner15 = ( 1.0 * _Time.y * _Vector1 + uv_TextureSample0);
				float2 coords13 = panner15 * _NoiseScale1;
				float2 id13 = 0;
				float2 uv13 = 0;
				float voroi13 = voronoi13( coords13, time13, id13, uv13, 0 );
				float2 panner39 = ( 1.0 * _Time.y * _Vector2 + uv_TextureSample0);
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				
				
				finalColor = tex2D( _MainTex, ( ( _Float1 * ( voroi2 * voroi13 * tex2D( _TextureSample0, panner39 ).r ) ) + uv_MainTex ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
0;24;1920;1035;2138.647;559.2939;1.745899;True;False
Node;AmplifyShaderEditor.CommentaryNode;19;-1290.332,329.9425;Inherit;False;877;372;疏噪点;4;14;15;18;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1293.413,-252.5781;Inherit;False;886.1017;493.5764;密噪点;6;2;4;7;11;8;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;17;-1238.345,17.9981;Inherit;False;Property;_Vector0;V速度1;2;0;Create;False;0;0;0;False;0;False;0,-1;0,-0.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1243.413,-202.5781;Inherit;False;0;21;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;18;-1240.332,481.9424;Inherit;False;Property;_Vector1;V速度2;3;0;Create;False;0;0;0;False;0;False;0,-0.5;0,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;40;-1251.887,794.3828;Inherit;False;Property;_Vector2;V速度3;4;0;Create;False;0;0;0;False;0;False;0,-0.23;0,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;8;-951.3445,124.9983;Inherit;False;Property;_NoiseScale;噪点大小;0;0;Create;False;0;0;0;False;0;False;5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;7;-968.3445,-178.0018;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.4;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-962.3445,-21.00193;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;15;-984.455,368.5378;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.4;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-949.7493,562.9583;Inherit;False;Property;_NoiseScale1;噪点大小2;1;0;Create;False;0;0;0;False;0;False;3.11;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;39;-900.2325,775.7144;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;21;-665.2832,774.1068;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;cd4a16aa7de3c4c608069572fd8ffdf6;cd4a16aa7de3c4c608069572fd8ffdf6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VoronoiNode;13;-613.3314,399.9425;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.VoronoiNode;2;-607.3109,-81.36495;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-293.1552,229.4222;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-249.4306,-4.95914;Inherit;False;Property;_Float1;强度;7;0;Create;False;0;0;0;False;0;False;1.07;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-233.6455,522.2526;Inherit;False;0;32;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-28.64469,55.16176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;80.94868,377.3808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;32;301.637,196.1279;Inherit;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;0;False;0;False;-1;7387ed2213b8d4d41ba7ba09e0da5f68;7387ed2213b8d4d41ba7ba09e0da5f68;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;616.2165,52.46146;Float;False;True;-1;2;ASEMaterialInspector;100;1;Fire;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;7;0;4;0
WireConnection;7;2;17;0
WireConnection;15;0;4;0
WireConnection;15;2;18;0
WireConnection;39;0;4;0
WireConnection;39;2;40;0
WireConnection;21;1;39;0
WireConnection;13;0;15;0
WireConnection;13;1;11;0
WireConnection;13;2;14;0
WireConnection;2;0;7;0
WireConnection;2;1;11;0
WireConnection;2;2;8;0
WireConnection;20;0;2;0
WireConnection;20;1;13;0
WireConnection;20;2;21;1
WireConnection;36;0;37;0
WireConnection;36;1;20;0
WireConnection;35;0;36;0
WireConnection;35;1;34;0
WireConnection;32;1;35;0
WireConnection;0;0;32;0
ASEEND*/
//CHKSM=CB463B0A3EAD84C42848E6D39F2D4620AD9DCB68