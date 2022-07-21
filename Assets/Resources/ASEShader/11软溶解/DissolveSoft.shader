// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "DissolveSoft"
{
	Properties
	{
		_MainTex("主纹理", 2D) = "white" {}
		_Dissolve("溶解图", 2D) = "white" {}
		_Float1("溶解值", Range( 0 , 1)) = 1
		_Float0("Float 0", Range( -1 , 1)) = 1
		_Color0("颜色混合", Color) = (0,0,0,0)
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
			#define ASE_NEEDS_FRAG_COLOR


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
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color0;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _Dissolve;
			uniform float4 _Dissolve_ST;
			uniform float _Float0;
			uniform float _Float1;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
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
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
				float2 uv_Dissolve = i.ase_texcoord1.xy * _Dissolve_ST.xy + _Dissolve_ST.zw;
				float4 appendResult13 = (float4((( _Color0 * tex2DNode1 * i.ase_color )).rgb , ( tex2DNode1.a * i.ase_color.a * saturate( ( tex2D( _Dissolve, uv_Dissolve ).r + _Float0 + ( _Float1 * -2.0 ) ) ) )));
				
				
				finalColor = appendResult13;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
-1920;24;1920;1035;2358.766;-114.2439;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;10;-1833.953,782.7333;Inherit;False;597.4373;242.9644;-2让溶解图每个像素都减去相同值,保留它的渐变;3;9;8;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;6;-1816.043,350.7003;Inherit;False;370;360.3731;+1的时候 让溶解图为0 的地方也为1,这样就不影响原图的透过显示;2;2;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1783.953,832.7333;Inherit;False;Property;_Float1;溶解值;2;0;Create;False;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1676.568,939.9219;Inherit;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1718.419,617.0735;Inherit;False;Property;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;1;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;18;-1130.749,110.4971;Inherit;False;241;257;使用粒子自定义顶点数据,去除报错;1;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-1766.043,400.7003;Inherit;True;Property;_Dissolve;溶解图;1;0;Create;False;0;0;0;False;0;False;-1;cd4a16aa7de3c4c608069572fd8ffdf6;cd4a16aa7de3c4c608069572fd8ffdf6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1398.516,840.2011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-1024.083,-332.7682;Inherit;False;Property;_Color0;颜色混合;4;0;Create;False;0;0;0;False;0;False;0,0,0,0;1,0.964141,0.4292453,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1108.632,-100.4077;Inherit;True;Property;_MainTex;主纹理;0;0;Create;False;0;0;0;False;0;False;-1;a78bffbeb81b48ae9ec71ad7969613e5;c35fe602e21b38542ba33e1db2731a5f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-1111.008,458.1292;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;15;-1080.749,160.4971;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-686.6973,-68.11237;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;11;-851.4647,388.215;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-446.9065,342.9181;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;12;-523.4517,-67.05632;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-235.5555,91.58107;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;55.40562,-55.40563;Float;False;True;-1;2;ASEMaterialInspector;100;1;DissolveSoft;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;3;0;2;1
WireConnection;3;1;4;0
WireConnection;3;2;9;0
WireConnection;16;0;20;0
WireConnection;16;1;1;0
WireConnection;16;2;15;0
WireConnection;11;0;3;0
WireConnection;14;0;1;4
WireConnection;14;1;15;4
WireConnection;14;2;11;0
WireConnection;12;0;16;0
WireConnection;13;0;12;0
WireConnection;13;3;14;0
WireConnection;0;0;13;0
ASEEND*/
//CHKSM=AD9EA5581A42FA53C3E63DE8AD6686911758F31E