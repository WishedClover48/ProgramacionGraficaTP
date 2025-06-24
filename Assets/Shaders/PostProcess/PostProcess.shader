// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcess"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		_Intensity("Intensity", Float) = 0.1
		_Step("Step", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Step;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform float _Intensity;
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 Screen6 = tex2D( _MainTex, uv_MainTex );
				float Step110 = _Step;
				float4 screenPos = i.ase_texcoord4;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 appendResult98 = (float4(ase_grabScreenPosNorm.r , ( 1.0 - ase_grabScreenPosNorm.g ) , ase_grabScreenPosNorm.b , ase_grabScreenPosNorm.a));
				float2 uv_TextureSample1 = i.uv.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 UVDistorted83 = ( appendResult98 + float4( ( UnpackNormal( tex2D( _TextureSample1, uv_TextureSample1 ) ) * _Intensity ) , 0.0 ) );
				float4 BluredScreen107 = tex2D( _MainTex, UVDistorted83.xy );
				float dotResult11 = dot( BluredScreen107 , float4( float3(0.2,0.7,0.1) , 0.0 ) );
				float4 DarkScreen18 = ( step( Step110 , dotResult11 ) * Screen6 );
				float dotResult45 = dot( BluredScreen107 , float4( float3(0.5,0.5,0.5) , 0.0 ) );
				float4 DS249 = ( step( Step110 , dotResult45 ) * Screen6 );
				float dotResult62 = dot( BluredScreen107 , float4( float3(0.3,0.1,0.7) , 0.0 ) );
				float4 DS366 = ( step( Step110 , dotResult62 ) * Screen6 );
				float dotResult71 = dot( BluredScreen107 , float4( float3(0.9,0.1,0.2) , 0.0 ) );
				float4 DS475 = ( step( Step110 , dotResult71 ) * Screen6 );
				

				finalColor = ( Screen6 + DarkScreen18 + DS249 + DS366 + DS475 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;802;1562;552;-576.6188;351.8557;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;87;-708.5836,2229.173;Inherit;False;1326.706;469;Distortion;8;78;79;81;82;83;88;98;100;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GrabScreenPosition;81;-665.8834,2283.073;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;79;-679.5837,2505.273;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;f439b5f5edf46954e9e0ca59287904b2;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;101;-245.2586,2284.548;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-376.4519,2622.78;Inherit;False;Property;_Intensity;Intensity;1;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;100;-292.9586,2327.85;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-27.75858,2305.749;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-192.7644,2483.387;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;185.4164,2352.273;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;399.9493,2349.006;Inherit;False;UVDistorted;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;104;-1060.787,-277.3877;Inherit;False;691.19;283;Screen;3;107;106;105;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;105;-994.1954,-226.3973;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;108;-1064.484,-143.4375;Inherit;False;83;UVDistorted;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;106;-864.903,-231.2462;Inherit;True;Property;_TextureSample2;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;7;-1064,-605.5;Inherit;False;691.19;283;Screen;3;1;2;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-997.4082,-554.5096;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;58;-307.8249,408.3792;Inherit;False;1197.411;472.8981; DS 2;8;66;65;64;63;62;60;59;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-566.0509,-230.7189;Inherit;False;BluredScreen;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;109;1591.214,-68.80147;Inherit;False;Property;_Step;Step;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;19;-308.4821,-595.174;Inherit;False;1197.411;472.8981;Dark Screen;8;13;12;11;14;16;15;18;111;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-317.871,-84.38589;Inherit;False;1197.411;472.8981; DS 2;8;51;50;49;48;47;45;44;112;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;67;-303.7106,901.4904;Inherit;False;1197.411;472.8981; DS 2;8;75;74;73;72;71;69;68;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;60;-257.8251,696.6376;Inherit;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;0;False;0;False;0.3,0.1,0.7;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;2;-868.1157,-559.3585;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;59;-254.8251,626.6376;Inherit;False;107;BluredScreen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-264.8712,133.8726;Inherit;False;107;BluredScreen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;12;-258.4822,-306.9155;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.2,0.7,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;13;-260.4822,-383.9155;Inherit;False;107;BluredScreen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;47;-267.8712,203.8726;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;68;-250.7108,1119.749;Inherit;False;107;BluredScreen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;69;-253.7108,1189.749;Inherit;False;Constant;_Vector3;Vector 3;1;0;Create;True;0;0;0;False;0;False;0.9,0.1,0.2;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;1743.214,-67.80145;Inherit;False;Step;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;62;-8.825265,636.6376;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-37.88672,972.4985;Inherit;False;110;Step;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;11;-9.482203,-366.9155;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-87.88672,-536.5015;Inherit;False;110;Step;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-569.2637,-558.8312;Inherit;False;Screen;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-69.88672,466.4985;Inherit;False;110;Step;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;71;-4.710815,1129.749;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;45;-18.87118,143.8726;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-41.88672,-23.50146;Inherit;False;110;Step;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;167.1289,181.8726;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;14;166.5178,-537.9158;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;63;167.1748,465.6374;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;177.1747,674.6376;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;181.2893,1167.749;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;72;171.2893,958.7485;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;48;157.1289,-27.12766;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;176.5178,-328.9155;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;516.1283,-29.12766;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;525.5176,-539.9158;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;530.2887,956.7485;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;526.1743,463.6374;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;660.7386,-545.1738;Inherit;False;DarkScreen;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;665.5095,951.4905;Inherit;False;DS4;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;662.395,458.3794;Inherit;False;DS3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;651.3492,-34.38572;Inherit;False;DS2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;1090.536,153.358;Inherit;False;66;DS3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;1090.536,236.358;Inherit;False;75;DS4;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;1090.44,78.14709;Inherit;False;49;DS2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;1096.44,-64.85291;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;1092.44,4.147095;Inherit;False;18;DarkScreen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;1314.44,31.14709;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1620.356,23.80087;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostProcess;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;101;0;81;1
WireConnection;100;0;81;2
WireConnection;98;0;101;0
WireConnection;98;1;100;0
WireConnection;98;2;81;3
WireConnection;98;3;81;4
WireConnection;88;0;79;0
WireConnection;88;1;78;0
WireConnection;82;0;98;0
WireConnection;82;1;88;0
WireConnection;83;0;82;0
WireConnection;106;0;105;0
WireConnection;106;1;108;0
WireConnection;107;0;106;0
WireConnection;2;0;1;0
WireConnection;110;0;109;0
WireConnection;62;0;59;0
WireConnection;62;1;60;0
WireConnection;11;0;13;0
WireConnection;11;1;12;0
WireConnection;6;0;2;0
WireConnection;71;0;68;0
WireConnection;71;1;69;0
WireConnection;45;0;51;0
WireConnection;45;1;47;0
WireConnection;14;0;111;0
WireConnection;14;1;11;0
WireConnection;63;0;113;0
WireConnection;63;1;62;0
WireConnection;72;0;114;0
WireConnection;72;1;71;0
WireConnection;48;0;112;0
WireConnection;48;1;45;0
WireConnection;50;0;48;0
WireConnection;50;1;44;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;74;0;72;0
WireConnection;74;1;73;0
WireConnection;65;0;63;0
WireConnection;65;1;64;0
WireConnection;18;0;15;0
WireConnection;75;0;74;0
WireConnection;66;0;65;0
WireConnection;49;0;50;0
WireConnection;56;0;57;0
WireConnection;56;1;52;0
WireConnection;56;2;53;0
WireConnection;56;3;76;0
WireConnection;56;4;77;0
WireConnection;0;0;56;0
ASEEND*/
//CHKSM=21598A7C13000C6BA98D8EE80886F175649BCB8A