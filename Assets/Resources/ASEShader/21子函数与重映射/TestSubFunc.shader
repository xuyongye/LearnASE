// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TestSubFunc"
{
	Properties
	{
		_Texture0("主纹理", 2D) = "white" {}
		_Texture1("溶解图", 2D) = "white" {}
		_Float2("硬软程度", Range( 0 , 1)) = 0.282353
		_Float3("溶解进程", Range( 0 , 1)) = 0.3529412
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

			uniform sampler2D _Texture0;
			uniform float4 _Texture0_ST;
			uniform float _Float2;
			uniform sampler2D _Texture1;
			uniform float4 _Texture1_ST;
			uniform float _Float3;

			
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
				float2 uv_Texture0 = i.ase_texcoord1.xy * _Texture0_ST.xy + _Texture0_ST.zw;
				float4 tex2DNode1_g1 = tex2D( _Texture0, uv_Texture0 );
				float temp_output_20_0_g1 = (0.51 + (_Float2 - 0.0) * (1.0 - 0.51) / (1.0 - 0.0));
				float2 uv_Texture1 = i.ase_texcoord1.xy * _Texture1_ST.xy + _Texture1_ST.zw;
				float smoothstepResult12_g1 = smoothstep( ( 1.0 - temp_output_20_0_g1 ) , temp_output_20_0_g1 , ( tex2D( _Texture1, uv_Texture1 ).r + 1.0 + ( (0.0 + (_Float3 - 0.0) * (1.05 - 0.0) / (1.0 - 0.0)) * -2.0 ) ));
				float4 appendResult16_g1 = (float4((tex2DNode1_g1).rgb , ( tex2DNode1_g1.a * smoothstepResult12_g1 )));
				
				
				finalColor = appendResult16_g1;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
-1735;133;1459;814;1353.193;490.6802;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-659.5,130;Inherit;False;Property;_Float2;硬软程度;2;0;Create;False;0;0;0;False;0;False;0.282353;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-661.5,208;Inherit;False;Property;_Float3;溶解进程;3;0;Create;False;0;0;0;False;0;False;0.3529412;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-628.5,-262;Inherit;True;Property;_Texture0;主纹理;0;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;4;-623.6002,-62.39999;Inherit;True;Property;_Texture1;溶解图;1;0;Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;1;-146.5,-60;Inherit;False;SoftDIssolve;-1;;1;662641002c97a5245a0895be8e778970;0;4;2;SAMPLER2D;0;False;18;SAMPLER2D;0;False;21;FLOAT;0;False;22;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;168,-58;Float;False;True;-1;2;ASEMaterialInspector;100;1;TestSubFunc;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;1;2;3;0
WireConnection;1;18;4;0
WireConnection;1;21;5;0
WireConnection;1;22;6;0
WireConnection;0;0;1;0
ASEEND*/
//CHKSM=1950935C7782F65F9E1C485873E973CA81C31B89