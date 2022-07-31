// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "xinhaoganrao"
{
	Properties
	{
		_Texture0("主纹理", 2D) = "white" {}
		_TextureSample3("扰动纹理", 2D) = "white" {}
		_offset("偏移量", Vector) = (0.03,0,-0.03,0)
		_Float1("sin速度", Float) = 0

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

			uniform sampler2D _Texture0;
			uniform sampler2D _TextureSample3;
			uniform float4 _TextureSample3_ST;
			uniform float _Float1;
			uniform float4 _offset;

			
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
				float2 texCoord5 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 uv_TextureSample3 = i.ase_texcoord1.xy * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
				float2 panner8 = ( 1.0 * _Time.y * float2( 1,0 ) + uv_TextureSample3);
				float mulTime28 = _Time.y * _Float1;
				float temp_output_32_0 = (0.0 + (sin( mulTime28 ) - 0.0) * (0.1 - 0.0) / (1.0 - 0.0));
				float2 appendResult14 = (float2(( texCoord5.x + ( (-0.5 + (tex2D( _TextureSample3, panner8 ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) * temp_output_32_0 ) ) , texCoord5.y));
				float4 break19 = ( (0.0 + (temp_output_32_0 - 0.0) * (1.0 - 0.0) / (0.1 - 0.0)) * _offset );
				float2 appendResult20 = (float2(break19.x , break19.y));
				float4 tex2DNode3 = tex2D( _Texture0, ( appendResult14 + appendResult20 ) );
				float2 appendResult21 = (float2(break19.z , break19.w));
				float4 appendResult24 = (float4(tex2DNode3.r , tex2D( _Texture0, appendResult14 ).g , tex2D( _Texture0, ( appendResult14 + appendResult21 ) ).b , tex2DNode3.a));
				
				
				finalColor = appendResult24;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
-1920;751;1920;944;3283.977;547.7375;1.685127;False;False
Node;AmplifyShaderEditor.CommentaryNode;34;-2429.35,343.4785;Inherit;False;890.6931;257;扰动的强度. 只需要很小的数值.所以重映射到0.1. sin节点会在-0.1 - 0.1中来回. 就可以在干扰和不干扰中来回切换的动画;4;30;28;29;32;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2379.35,429.8975;Inherit;False;Property;_Float1;sin速度;3;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;33;-2783.644,-161.958;Inherit;False;1208.636;429.5995;扰动的纹理,remap 0-1 到 -0.5 - 0.5 避免同一个方向移动. 产生图片往一个方向偏移;5;6;26;7;9;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;28;-2169.577,422.614;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;9;-2703.535,103.6415;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-2733.644,-111.958;Inherit;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;29;-1971.455,424.0706;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;8;-2401.742,-14.75815;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;32;-1745.657,393.4785;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-1497.553,339.6152;Inherit;False;257;257;remap回0-1 做运算;1;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;6;-2175.539,-45.95806;Inherit;True;Property;_TextureSample3;扰动纹理;1;0;Create;False;0;0;0;False;0;False;-1;21e1fd9fed8d3c44d9d644cfb401dd8a;21e1fd9fed8d3c44d9d644cfb401dd8a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;18;-1424.257,637.2121;Inherit;False;Property;_offset;偏移量;2;0;Create;False;0;0;0;False;0;False;0.03,0,-0.03,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;16;-1447.553,389.6152;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;35;-1521.294,0.5292432;Inherit;False;212;185;减少扰动强度.;1;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;26;-1782.008,-35.54995;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-1252.143,-372.1844;Inherit;False;202;185;只做u方向的位移;1;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1194.257,495.212;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1567.664,-292.8616;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1471.294,50.52923;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1202.143,-322.1844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;37;-902.3802,285.2739;Inherit;False;298.5042;342.0761;左右两方的偏移uv;2;21;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;19;-1031.256,488.212;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;39;-1054.135,-112.6571;Inherit;False;211;185;组合回UV;1;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-764.876,492.35;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-852.3802,335.2739;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;41;-700.5909,3.033327;Inherit;False;334.3701;319.2016;偏移uv 加上原uv 就是实际的图片偏移uv;2;23;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-1004.135,-62.65711;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-897.7892,-311.0772;Inherit;True;Property;_Texture0;主纹理;0;0;Create;False;0;0;0;False;0;False;6f410c15ce9be2741bae77a30a336748;6f410c15ce9be2741bae77a30a336748;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;42;-371.7253,-441.88;Inherit;False;370;280;原地扰动uv;1;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-357.1561,-147.3708;Inherit;False;372.8694;538.0219;左右偏移扰动uv;2;4;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-650.5909,53.03333;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-627.4207,195.0349;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;-307.1561,-97.3708;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-304.2867,160.6511;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;44;98.36839,-136.6371;Inherit;False;289;304;各取一个颜色就会有颜色分离的扰动;1;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-321.7253,-391.88;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;24;148.3684,-86.6371;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;468.9068,-97.89182;Float;False;True;-1;2;ASEMaterialInspector;100;1;xinhaoganrao;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;28;0;30;0
WireConnection;29;0;28;0
WireConnection;8;0;7;0
WireConnection;8;2;9;0
WireConnection;32;0;29;0
WireConnection;6;1;8;0
WireConnection;16;0;32;0
WireConnection;26;0;6;1
WireConnection;17;0;16;0
WireConnection;17;1;18;0
WireConnection;12;0;26;0
WireConnection;12;1;32;0
WireConnection;11;0;5;1
WireConnection;11;1;12;0
WireConnection;19;0;17;0
WireConnection;21;0;19;2
WireConnection;21;1;19;3
WireConnection;20;0;19;0
WireConnection;20;1;19;1
WireConnection;14;0;11;0
WireConnection;14;1;5;2
WireConnection;22;0;14;0
WireConnection;22;1;20;0
WireConnection;23;0;14;0
WireConnection;23;1;21;0
WireConnection;3;0;1;0
WireConnection;3;1;22;0
WireConnection;4;0;1;0
WireConnection;4;1;23;0
WireConnection;2;0;1;0
WireConnection;2;1;14;0
WireConnection;24;0;3;1
WireConnection;24;1;2;2
WireConnection;24;2;4;3
WireConnection;24;3;3;4
WireConnection;0;0;24;0
ASEEND*/
//CHKSM=D6FE424DDF8EDD14C456CCB4A423136B6DC8D35D