// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader ""
{
	Properties
	{
		_TextureSample0("主纹理", 2D) = "white" {}
		_TextureSample1("FlowMap图", 2D) = "white" {}
		_TextureSample2("溶解图", 2D) = "white" {}
		_dissproperty("扭曲溶解进程", Range( 0 , 1)) = 0
		_SmoothValue("溶解软硬度", Range( 0.51 , 1)) = 0.51
		[Enum(particleData,1,valueData,0)]_Float2("控制模式", Float) = 0
		_Float3("遮罩范围", Range( 0 , 1)) = 0.3294118
		_maskSmoothD("遮罩平滑过渡程度", Range( 1 , 10)) = 2.270588
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

			uniform sampler2D _TextureSample0;
			uniform float4 _TextureSample0_ST;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float _dissproperty;
			uniform float _Float2;
			uniform float _SmoothValue;
			uniform sampler2D _TextureSample2;
			uniform float _Float3;
			uniform float _maskSmoothD;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xyz = v.ase_texcoord.xyz;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.w = 0;
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
				float2 uv_TextureSample0 = i.ase_texcoord1.xyz.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float2 uv_TextureSample1 = i.ase_texcoord1.xyz.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 tex2DNode14 = tex2D( _TextureSample1, uv_TextureSample1 );
				float2 appendResult15 = (float2(tex2DNode14.r , tex2DNode14.g));
				float3 texCoord29 = i.ase_texcoord1.xyz;
				texCoord29.xy = i.ase_texcoord1.xyz.xy * float2( 1,1 ) + float2( 0,0 );
				float lerpResult28 = lerp( _dissproperty , texCoord29.z , _Float2);
				float2 lerpResult13 = lerp( uv_TextureSample0 , appendResult15 , lerpResult28);
				float4 tex2DNode1 = tex2D( _TextureSample0, lerpResult13 );
				float smoothstepResult24 = smoothstep( ( 1.0 - _SmoothValue ) , _SmoothValue , ( tex2D( _TextureSample2, lerpResult13 ).r + 1.0 + ( lerpResult28 * -2.0 ) ));
				float2 texCoord33 = i.ase_texcoord1.xyz.xy * float2( 1,1 ) + float2( 0,0 );
				float4 appendResult10 = (float4((( tex2DNode1 * i.ase_color )).rgb , ( tex2DNode1.a * i.ase_color.a * smoothstepResult24 * saturate( ( ( ( 1.0 - distance( texCoord33 , float2( 0.5,0.5 ) ) ) - _Float3 ) * _maskSmoothD ) ) )));
				
				
				finalColor = appendResult10;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
-1920;97;1268;683;1905.213;-645.3366;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;32;-1604.712,-496.9791;Inherit;False;589.2203;462.4139;如果这两个反过来从扭曲到正常会会像烟雾散出;3;12;14;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-2571.323,867.5173;Inherit;False;968.3522;521.3683;uv图中心为0.5 所以它与0.5的距离 中间是0. 这样用1 - 就会得到中心往外的一个圆形渐变遮罩图;4;33;34;36;38;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-1718.718,115.3433;Inherit;False;680.1808;509.9286;使用lerp开做控制开关. 当alpha为1时使用粒子自定义数据. 为0时由进程变量控制;4;28;16;30;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-2521.323,917.5172;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1554.712,-264.5652;Inherit;True;Property;_TextureSample1;FlowMap图;1;0;Create;False;0;0;0;False;0;False;-1;ae1f1f9c4091f7e4f9da539aecb33f02;ae1f1f9c4091f7e4f9da539aecb33f02;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;36;-2481.971,1219.886;Inherit;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;30;-1608.052,509.2719;Inherit;False;Property;_Float2;控制模式;5;1;[Enum];Create;False;0;2;particleData;1;valueData;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1668.718,165.3433;Inherit;False;Property;_dissproperty;扭曲溶解进程;3;0;Create;False;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-1644.077,297.0866;Inherit;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;21;-713.2162,274.2397;Inherit;False;737.7578;511.5277;软溶解 + 1 再  - 0 ~ -2 扩大渐变范围, uv 同时也采用扭曲过后的. 以免效果各搞各的;5;23;22;20;19;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1403.847,-446.9791;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;-1176.491,-237.3147;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;28;-1220.537,254.5992;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;34;-2126.973,1072.886;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;41;-1593.81,1017.736;Inherit;False;635;304;控制遮罩范围;2;39;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;44;-938.8098,1026.736;Inherit;False;591;304;控制遮罩平滑的程度;2;42;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-691.4585,692.9676;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;-1831.972,1070.886;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;47.97388,573.945;Inherit;False;1075.644;443.8732;平滑阶梯:主要用来重新映射溶解图的范围. 让小于Min的为0 大于max的为1  当0.51的时候 min = 0.49 max = 0.51 所以渐变范围只有0.02 接近非黑即白的硬边;3;24;25;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;13;-851.7697,-192.2887;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1543.81,1203.736;Inherit;False;Property;_Float3;遮罩范围;6;0;Create;False;0;0;0;False;0;False;0.3294118;0.3294118;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-663.2162,324.2397;Inherit;True;Property;_TextureSample2;溶解图;2;0;Create;False;0;0;0;False;0;False;-1;c94ccb9a42afb1d40ba95161bbda6baf;823a2869cbf200f4991f196a5e9b84ed;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-487.6582,676.1675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;39;-1193.81,1067.736;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;82.97392,886.2186;Inherit;False;Property;_SmoothValue;溶解软硬度;4;0;Create;False;0;0;0;False;0;False;0.51;0.81;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-629.8584,539.1675;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-888.8096,1150.736;Inherit;False;Property;_maskSmoothD;遮罩平滑过渡程度;7;0;Create;False;0;0;0;False;0;False;2.270588;2.317647;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-223.4587,420.7675;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;2;-510.2897,-18.02249;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;26;323.8736,688.5181;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-582.8095,1076.736;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-583.5717,-266.9113;Inherit;True;Property;_TextureSample0;主纹理;0;0;Create;False;0;0;0;False;0;False;-1;8e3c4c74f2b09f04da3ec332bf5e980e;8e3c4c74f2b09f04da3ec332bf5e980e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;11;413.0573,-127.8441;Inherit;False;589.2731;410.0646;单独弄出来a通道需要和溶解进行运算;2;10;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;24;705.8189,623.945;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;-288.6989,1047.956;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-142.3149,-239.851;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;9;106.07,-241.1682;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;515.3306,86.97595;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;822.2365,57.42198;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1183.664,138.4726;Float;False;True;-1;2;ASEMaterialInspector;100;1;;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;15;0;14;1
WireConnection;15;1;14;2
WireConnection;28;0;16;0
WireConnection;28;1;29;3
WireConnection;28;2;30;0
WireConnection;34;0;33;0
WireConnection;34;1;36;0
WireConnection;38;0;34;0
WireConnection;13;0;12;0
WireConnection;13;1;15;0
WireConnection;13;2;28;0
WireConnection;18;1;13;0
WireConnection;22;0;28;0
WireConnection;22;1;23;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;19;0;18;1
WireConnection;19;1;20;0
WireConnection;19;2;22;0
WireConnection;26;0;25;0
WireConnection;42;0;39;0
WireConnection;42;1;43;0
WireConnection;1;1;13;0
WireConnection;24;0;19;0
WireConnection;24;1;26;0
WireConnection;24;2;25;0
WireConnection;46;0;42;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;9;0;3;0
WireConnection;7;0;1;4
WireConnection;7;1;2;4
WireConnection;7;2;24;0
WireConnection;7;3;46;0
WireConnection;10;0;9;0
WireConnection;10;3;7;0
WireConnection;0;0;10;0
ASEEND*/
//CHKSM=D77C2995F105A483EFDCAADBE20FE9B113093953