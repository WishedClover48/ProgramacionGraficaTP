// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Pommel"
{
	Properties
	{
		_goldtexturedbackground("gold-textured-background", 2D) = "white" {}
		_goldtexturedbackground_ambient("gold-textured-background_ambient", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _goldtexturedbackground;
		uniform float4 _goldtexturedbackground_ST;
		uniform sampler2D _goldtexturedbackground_ambient;
		uniform float4 _goldtexturedbackground_ambient_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_goldtexturedbackground = i.uv_texcoord * _goldtexturedbackground_ST.xy + _goldtexturedbackground_ST.zw;
			o.Albedo = tex2D( _goldtexturedbackground, uv_goldtexturedbackground ).rgb;
			o.Metallic = 1.0;
			o.Smoothness = 0.5;
			float2 uv_goldtexturedbackground_ambient = i.uv_texcoord * _goldtexturedbackground_ambient_ST.xy + _goldtexturedbackground_ambient_ST.zw;
			o.Occlusion = tex2D( _goldtexturedbackground_ambient, uv_goldtexturedbackground_ambient ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;511;1488;483;1996.746;269.0586;1.850732;True;False
Node;AmplifyShaderEditor.SamplerNode;6;-356.2529,-143.6905;Inherit;True;Property;_goldtexturedbackground;gold-textured-background;0;0;Create;True;0;0;0;False;0;False;-1;c00568c99fbe21548879997163a02506;c00568c99fbe21548879997163a02506;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-339.9495,187.6015;Inherit;False;Constant;_Metallic;Metallic;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-360.9495,281.6016;Inherit;False;Constant;_Roughness;Roughness;0;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-485.9397,384.1655;Inherit;True;Property;_goldtexturedbackground_ambient;gold-textured-background_ambient;1;0;Create;True;0;0;0;False;0;False;-1;69527dcc367923a4a8ab595d3b2c8919;69527dcc367923a4a8ab595d3b2c8919;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Pommel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;0;6;0
WireConnection;0;3;4;0
WireConnection;0;4;5;0
WireConnection;0;5;10;0
ASEEND*/
//CHKSM=AA0C981667D82A1CAFE5E757A9E9DB567EE9EA33