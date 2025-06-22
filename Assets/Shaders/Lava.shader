// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lava"
{
	Properties
	{
		_LavaTexture("LavaTexture", 2D) = "white" {}
		_FlowSpeed("FlowSpeed", Vector) = (1,1,0,0)
		_FlowMap("FlowMap", 2D) = "white" {}
		_FlowDistortion("FlowDistortion", Float) = 0
		_Tilling("Tilling", Float) = 1
		_FlowIntensity("FlowIntensity", Float) = -0.2
		_StonePattern("StonePattern", 2D) = "white" {}
		_Stonetexture("Stonetexture", 2D) = "white" {}
		_StoneNormals_Texture("StoneNormals_Texture", 2D) = "white" {}
		_StoneColor("StoneColor", Color) = (0,0,0,0)
		_StoneNormals("StoneNormals", Float) = 0
		_WavesSpeed("WavesSpeed", Float) = 0
		_WavesStrength("WavesStrength", Float) = 0
		_EmissionIntensity("EmissionIntensity", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _WavesSpeed;
		uniform float _WavesStrength;
		uniform sampler2D _StonePattern;
		uniform float2 _FlowSpeed;
		uniform float _Tilling;
		uniform sampler2D _FlowMap;
		uniform float _FlowIntensity;
		uniform float _FlowDistortion;
		uniform sampler2D _StoneNormals_Texture;
		uniform float _StoneNormals;
		uniform sampler2D _Stonetexture;
		uniform float4 _StoneColor;
		uniform sampler2D _LavaTexture;
		uniform float _EmissionIntensity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float waves128 = ( sin( ( ( ase_worldPos.x + ase_worldPos.z ) + ( _Time.y * _WavesSpeed ) ) ) * _WavesStrength );
			float3 temp_cast_0 = (waves128).xxx;
			v.vertex.xyz += temp_cast_0;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float Tilling54 = _Tilling;
			float2 temp_cast_0 = (Tilling54).xx;
			float2 uv_TexCoord36 = i.uv_texcoord * temp_cast_0;
			float2 temp_cast_2 = (_FlowIntensity).xx;
			float2 panner48 = ( 1.0 * _Time.y * temp_cast_2 + uv_TexCoord36);
			float4 lerpResult46 = lerp( float4( uv_TexCoord36, 0.0 , 0.0 ) , tex2D( _FlowMap, panner48 ) , _FlowDistortion);
			float2 panner40 = ( 1.0 * _Time.y * _FlowSpeed + lerpResult46.rg);
			float2 Flow24 = panner40;
			float4 tex2DNode51 = tex2D( _StonePattern, Flow24 );
			float StoneBW100 = ( 1.0 - saturate( ( ( tex2DNode51.r + tex2DNode51.g + tex2DNode51.b ) * 10.0 ) ) );
			float4 temp_cast_4 = (StoneBW100).xxxx;
			float4 lerpResult98 = lerp( temp_cast_4 , tex2D( _StoneNormals_Texture, Flow24 ) , _StoneNormals);
			float4 StoneNormals91 = lerpResult98;
			o.Normal = StoneNormals91.rgb;
			float4 Albedo71 = ( StoneBW100 * ( tex2D( _Stonetexture, Flow24 ) * _StoneColor ) );
			o.Albedo = Albedo71.rgb;
			o.Emission = ( tex2D( _LavaTexture, Flow24 ) * _EmissionIntensity ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;525;1464;469;3350.545;387.6904;1;False;True
Node;AmplifyShaderEditor.RangedFloatNode;53;155.3285,-64.70204;Inherit;False;Property;_Tilling;Tilling;4;0;Create;True;0;0;0;False;0;False;1;14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-2574.975,-1628.503;Inherit;False;1859.465;634.5101;Flow y Panner;10;24;40;46;38;33;47;48;49;36;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;302.415,-66.64114;Inherit;False;Tilling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-2473.746,-1443.544;Inherit;False;54;Tilling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2369.592,-1201.904;Inherit;False;Property;_FlowIntensity;FlowIntensity;5;0;Create;True;0;0;0;False;0;False;-0.2;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-2305.648,-1458.965;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;48;-2171.592,-1233.904;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-1950.177,-1340.293;Inherit;True;Property;_FlowMap;FlowMap;2;0;Create;True;0;0;0;False;0;False;-1;None;b92e5f138ffc68b449e717d9c16e0c99;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-1810.225,-1093.848;Inherit;False;Property;_FlowDistortion;FlowDistortion;3;0;Create;True;0;0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;38;-1421.115,-1124.695;Inherit;False;Property;_FlowSpeed;FlowSpeed;1;0;Create;True;0;0;0;False;0;False;1,1;0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;46;-1613.625,-1459.348;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;40;-1230.766,-1271.126;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-982.5941,-1273.143;Inherit;False;Flow;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;104;-3095.068,-931.9657;Inherit;False;1321.271;346.0886;StoneBW Map;8;67;51;60;61;62;63;64;100;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-3045.068,-857.7518;Inherit;False;24;Flow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;51;-2866.519,-881.9657;Inherit;True;Property;_StonePattern;StonePattern;6;0;Create;True;0;0;0;False;0;False;-1;2e939ca52f7fb7640a3186a4a3fb00f6;2e939ca52f7fb7640a3186a4a3fb00f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-2579.462,-852.8214;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2584.863,-724.8211;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-2442.28,-850.1312;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;130;-1735.096,-461.0905;Inherit;False;1134.86;422.16;Waves;10;115;112;114;116;117;118;113;119;120;128;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;115;-1667.096,-266.0905;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1667.096,-189.0906;Inherit;False;Property;_WavesSpeed;WavesSpeed;11;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;105;-3318.411,-549.9764;Inherit;False;1548.271;573.5831;StoneAlbedo;7;70;66;73;68;101;65;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;63;-2314.938,-852.4946;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;114;-1685.096,-411.0905;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;70;-3268.411,-340.1749;Inherit;False;24;Flow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-1467.096,-259.0905;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;-2156.663,-853.6215;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;-1484.096,-374.0905;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;103;-1740.568,-938.9973;Inherit;False;1052.116;454.0342;StoneNormals;6;88;86;98;99;91;102;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;73;-2994.327,-184.1932;Inherit;False;Property;_StoneColor;StoneColor;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5188677,0.5188677,0.5188677,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;118;-1316.096,-311.0905;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-2001.989,-844.037;Inherit;True;StoneBW;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1690.568,-692.3259;Inherit;False;24;Flow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;66;-3016.75,-373.7038;Inherit;True;Property;_Stonetexture;Stonetexture;7;0;Create;True;0;0;0;False;0;False;-1;None;fabdebbf4eecf1b4fba85239b753f02c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-1240.096,-217.0906;Inherit;False;Property;_WavesStrength;WavesStrength;12;0;Create;True;0;0;0;False;0;False;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-1227.522,-654.2997;Inherit;False;Property;_StoneNormals;StoneNormals;10;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;-1505.062,-714.9631;Inherit;True;Property;_StoneNormals_Texture;StoneNormals_Texture;8;0;Create;True;0;0;0;False;0;False;-1;None;b23af15b7d6a3b148b706ff38d3a80ba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;101;-2580.277,-499.9766;Inherit;False;100;StoneBW;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;119;-1176.096,-305.0905;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2670.047,-318.0671;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-1282.458,-888.9973;Inherit;False;100;StoneBW;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;98;-1067.6,-885.0359;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-2237.285,-465.6036;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-1052.096,-292.0905;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-705.2343,90.66291;Inherit;False;24;Flow;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-440.5503,292.8176;Inherit;False;Property;_EmissionIntensity;EmissionIntensity;13;0;Create;True;0;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-828.4263,-307.116;Inherit;False;waves;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-1998.331,-470.5019;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-498.0342,68.2526;Inherit;True;Property;_LavaTexture;LavaTexture;0;0;Create;True;0;0;0;False;0;False;-1;None;2e939ca52f7fb7640a3186a4a3fb00f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-916.6411,-885.7896;Inherit;True;StoneNormals;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-78.95905,23.31403;Inherit;False;91;StoneNormals;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;-77.13721,-55.70917;Inherit;False;71;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;129;-44.9231,299.7234;Inherit;False;128;waves;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;-66.55029,89.8176;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;340.0834,36;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Lava;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;53;0
WireConnection;36;0;56;0
WireConnection;48;0;36;0
WireConnection;48;2;49;0
WireConnection;33;1;48;0
WireConnection;46;0;36;0
WireConnection;46;1;33;0
WireConnection;46;2;47;0
WireConnection;40;0;46;0
WireConnection;40;2;38;0
WireConnection;24;0;40;0
WireConnection;51;1;67;0
WireConnection;61;0;51;1
WireConnection;61;1;51;2
WireConnection;61;2;51;3
WireConnection;62;0;61;0
WireConnection;62;1;60;0
WireConnection;63;0;62;0
WireConnection;116;0;115;0
WireConnection;116;1;112;0
WireConnection;64;0;63;0
WireConnection;117;0;114;1
WireConnection;117;1;114;3
WireConnection;118;0;117;0
WireConnection;118;1;116;0
WireConnection;100;0;64;0
WireConnection;66;1;70;0
WireConnection;88;1;86;0
WireConnection;119;0;118;0
WireConnection;68;0;66;0
WireConnection;68;1;73;0
WireConnection;98;0;102;0
WireConnection;98;1;88;0
WireConnection;98;2;99;0
WireConnection;65;0;101;0
WireConnection;65;1;68;0
WireConnection;120;0;119;0
WireConnection;120;1;113;0
WireConnection;128;0;120;0
WireConnection;71;0;65;0
WireConnection;12;1;19;0
WireConnection;91;0;98;0
WireConnection;131;0;12;0
WireConnection;131;1;132;0
WireConnection;0;0;72;0
WireConnection;0;1;97;0
WireConnection;0;2;131;0
WireConnection;0;11;129;0
ASEEND*/
//CHKSM=5035C472B0C23CD92C165CBD326CA57CC60D7783