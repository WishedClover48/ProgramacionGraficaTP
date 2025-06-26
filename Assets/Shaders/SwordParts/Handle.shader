// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Handle"
{
	Properties
	{
		_Frequency("Frequency", Float) = 0
		_brown_leather_albedo_4k("brown_leather_albedo_4k", 2D) = "white" {}
		_brown_leather_nor_gl_4k("brown_leather_nor_gl_4k", 2D) = "bump" {}
		_brown_leather_rough_4k("brown_leather_rough_4k", 2D) = "white" {}
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
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Frequency;
		uniform sampler2D _brown_leather_nor_gl_4k;
		uniform float4 _brown_leather_nor_gl_4k_ST;
		uniform sampler2D _brown_leather_albedo_4k;
		uniform float4 _brown_leather_albedo_4k_ST;
		uniform sampler2D _brown_leather_rough_4k;
		uniform float4 _brown_leather_rough_4k_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float Lines18 = step( (0.0 + (saturate( sin( ( ( ase_worldPos.x + ase_worldPos.y ) * _Frequency ) ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) , 0.99 );
			float2 uv_brown_leather_nor_gl_4k = i.uv_texcoord * _brown_leather_nor_gl_4k_ST.xy + _brown_leather_nor_gl_4k_ST.zw;
			o.Normal = ( Lines18 * UnpackNormal( tex2D( _brown_leather_nor_gl_4k, uv_brown_leather_nor_gl_4k ) ) );
			float2 uv_brown_leather_albedo_4k = i.uv_texcoord * _brown_leather_albedo_4k_ST.xy + _brown_leather_albedo_4k_ST.zw;
			o.Albedo = ( tex2D( _brown_leather_albedo_4k, uv_brown_leather_albedo_4k ) * Lines18 ).rgb;
			float2 uv_brown_leather_rough_4k = i.uv_texcoord * _brown_leather_rough_4k_ST.xy + _brown_leather_rough_4k_ST.zw;
			o.Smoothness = ( tex2D( _brown_leather_rough_4k, uv_brown_leather_rough_4k ) * Lines18 ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
8;31;1904;975;2052.191;396.0787;1.344822;True;False
Node;AmplifyShaderEditor.CommentaryNode;32;-2724.947,-4.156178;Inherit;False;1789.379;460.5385;Lines Mask;9;4;6;10;13;23;17;24;18;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-2674.947,45.84366;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;9;-2453.615,341.2222;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;0;75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-2485.89,73.06989;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2200.948,102.8607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;13;-2058.306,100.719;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;23;-1850.672,102.1838;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;17;-1694.235,103.3198;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;24;-1396.673,104.1839;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.99;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-1163.762,100.9401;Inherit;False;Lines;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-811.0616,-174.5343;Inherit;True;Property;_brown_leather_albedo_4k;brown_leather_albedo_4k;1;0;Create;True;0;0;0;False;0;False;-1;a5d14b127da79754ebb335eb19f8bc98;a5d14b127da79754ebb335eb19f8bc98;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;19;-781.7764,53.0759;Inherit;False;18;Lines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-810.3492,173.7294;Inherit;True;Property;_brown_leather_nor_gl_4k;brown_leather_nor_gl_4k;2;0;Create;True;0;0;0;False;0;False;-1;f52b30a1f9e5a7448921a35e4a643495;f52b30a1f9e5a7448921a35e4a643495;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-811.2747,386.2774;Inherit;True;Property;_brown_leather_rough_4k;brown_leather_rough_4k;3;0;Create;True;0;0;0;False;0;False;-1;e0cb7170ddbfa3047b46aae067259c67;e0cb7170ddbfa3047b46aae067259c67;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;-774.4285,602.5962;Inherit;False;18;Lines;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-412.0182,173.4126;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-412.4088,393.0698;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-403.9716,-87.13733;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Handle;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;4;1
WireConnection;6;1;4;2
WireConnection;10;0;6;0
WireConnection;10;1;9;0
WireConnection;13;0;10;0
WireConnection;23;0;13;0
WireConnection;17;0;23;0
WireConnection;24;0;17;0
WireConnection;18;0;24;0
WireConnection;29;0;19;0
WireConnection;29;1;26;0
WireConnection;31;0;27;0
WireConnection;31;1;30;0
WireConnection;21;0;25;0
WireConnection;21;1;19;0
WireConnection;0;0;21;0
WireConnection;0;1;29;0
WireConnection;0;4;31;0
ASEEND*/
//CHKSM=7660F91FC1C040B90591EFFBFDB08309675CBA10