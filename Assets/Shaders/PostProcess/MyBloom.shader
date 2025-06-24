// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyBloom"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
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
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
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
				float dotResult11 = dot( Screen6 , float4( float3(0.2,0.7,0.1) , 0.0 ) );
				float4 DarkScreen18 = ( step( 0.5 , dotResult11 ) * Screen6 );
				float dotResult45 = dot( Screen6 , float4( float3(0.5,0.5,0.5) , 0.0 ) );
				float4 DS249 = ( step( 0.7 , dotResult45 ) * Screen6 );
				float dotResult62 = dot( Screen6 , float4( float3(0.3,0.1,0.7) , 0.0 ) );
				float4 DS366 = ( step( 0.6 , dotResult62 ) * Screen6 );
				float dotResult71 = dot( Screen6 , float4( float3(0.9,0.1,0.2) , 0.0 ) );
				float4 DS475 = ( step( 0.5 , dotResult71 ) * Screen6 );
				

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
0;751;1562;603;745.8507;225.5375;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;7;-1022,-601.5;Inherit;False;691.19;283;Screen;3;1;2;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-972,-540.5;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-853,-548.5;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;67;-303.7106,901.4904;Inherit;False;1197.411;472.8981; DS 2;8;75;74;73;72;71;70;69;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-514,-592.5;Inherit;False;Screen;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;58;-307.8249,408.3792;Inherit;False;1197.411;472.8981; DS 2;8;66;65;64;63;62;61;60;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;19;-308.4821,-595.174;Inherit;False;1197.411;472.8981;Dark Screen;8;13;12;11;17;14;16;15;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-317.871,-84.38589;Inherit;False;1197.411;472.8981; DS 2;8;51;50;49;48;47;46;45;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;69;-253.7108,1189.749;Inherit;False;Constant;_Vector3;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.9,0.1,0.2;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;59;-254.8251,626.6376;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;12;-258.4822,-306.9155;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.2,0.7,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;13;-255.4822,-376.9155;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;60;-257.8251,696.6376;Inherit;False;Constant;_Vector2;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.3,0.1,0.7;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;51;-264.8712,133.8726;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-250.7108,1119.749;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;47;-267.8712,203.8726;Inherit;False;Constant;_Vector1;Vector 0;1;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;61;12.17473,458.6374;Inherit;False;Constant;_Float2;Float 0;1;0;Create;True;0;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;62;-8.825265,636.6376;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;45;-18.87118,143.8726;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;16.2892,951.7485;Inherit;False;Constant;_Float3;Float 0;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;11;-9.482203,-366.9155;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;71;-4.710815,1129.749;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;11.5178,-544.9158;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;2.128825,-34.12767;Inherit;False;Constant;_Float1;Float 0;1;0;Create;True;0;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;72;171.2893,958.7485;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;181.2893,1167.749;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;177.1747,674.6376;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;63;167.1748,465.6374;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;48;157.1289,-27.12766;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;167.1289,181.8726;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;176.5178,-328.9155;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;14;166.5178,-537.9158;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;525.5176,-539.9158;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;526.1743,463.6374;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;530.2887,956.7485;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;516.1283,-29.12766;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;665.5095,951.4905;Inherit;False;DS4;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;662.395,458.3794;Inherit;False;DS3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;651.3492,-34.38572;Inherit;False;DS2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;660.7386,-545.1738;Inherit;False;DarkScreen;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;1096.44,-64.85291;Inherit;False;6;Screen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;1090.44,78.14709;Inherit;False;49;DS2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;1090.536,153.358;Inherit;False;66;DS3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;1092.44,4.147095;Inherit;False;18;DarkScreen;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;1090.536,236.358;Inherit;False;75;DS4;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;1314.44,31.14709;Inherit;False;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1510.532,-32.92187;Float;False;True;-1;2;ASEMaterialInspector;0;2;MyBloom;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;2;0;1;0
WireConnection;6;0;2;0
WireConnection;62;0;59;0
WireConnection;62;1;60;0
WireConnection;45;0;51;0
WireConnection;45;1;47;0
WireConnection;11;0;13;0
WireConnection;11;1;12;0
WireConnection;71;0;68;0
WireConnection;71;1;69;0
WireConnection;72;0;70;0
WireConnection;72;1;71;0
WireConnection;63;0;61;0
WireConnection;63;1;62;0
WireConnection;48;0;46;0
WireConnection;48;1;45;0
WireConnection;14;0;17;0
WireConnection;14;1;11;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;65;0;63;0
WireConnection;65;1;64;0
WireConnection;74;0;72;0
WireConnection;74;1;73;0
WireConnection;50;0;48;0
WireConnection;50;1;44;0
WireConnection;75;0;74;0
WireConnection;66;0;65;0
WireConnection;49;0;50;0
WireConnection;18;0;15;0
WireConnection;56;0;57;0
WireConnection;56;1;52;0
WireConnection;56;2;53;0
WireConnection;56;3;76;0
WireConnection;56;4;77;0
WireConnection;0;0;56;0
ASEEND*/
//CHKSM=697DA58D7A3868FC2C339125377311CBAA6F39DB