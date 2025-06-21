// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Rock"
{
	Properties
	{
		_TextureAlbedo("Texture Albedo", 2D) = "white" {}
		_TextureNormals("Texture Normals", 2D) = "white" {}
		_Metallic("Metallic", Float) = 0
		_VertexOffset("Vertex Offset", 2D) = "white" {}
		_RoughnessTexture("Roughness Texture", 2D) = "white" {}
		_StoneColor("StoneColor", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _VertexOffset;
		uniform float4 _VertexOffset_ST;
		uniform sampler2D _TextureNormals;
		uniform float4 _TextureNormals_ST;
		uniform sampler2D _TextureAlbedo;
		uniform float4 _TextureAlbedo_ST;
		uniform float4 _StoneColor;
		uniform float _Metallic;
		uniform sampler2D _RoughnessTexture;
		uniform float4 _RoughnessTexture_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_VertexOffset = v.texcoord * _VertexOffset_ST.xy + _VertexOffset_ST.zw;
			float2 Offset34 = ( ( 0.0 - 1 ) * float3( 0,1,0 ).xy * 0.0 ) + tex2Dlod( _VertexOffset, float4( uv_VertexOffset, 0, 0.0) ).rg;
			float3 LocalVertexOffset35 = ( ( float3( Offset34 ,  0.0 ) * float3(0,1,0) ) * 0.0 );
			v.vertex.xyz += LocalVertexOffset35;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureNormals = i.uv_texcoord * _TextureNormals_ST.xy + _TextureNormals_ST.zw;
			float4 Normals25 = tex2D( _TextureNormals, uv_TextureNormals );
			o.Normal = Normals25.rgb;
			float2 uv_TextureAlbedo = i.uv_texcoord * _TextureAlbedo_ST.xy + _TextureAlbedo_ST.zw;
			float4 Albedo22 = ( tex2D( _TextureAlbedo, uv_TextureAlbedo ) * _StoneColor );
			o.Albedo = Albedo22.rgb;
			float Metallic50 = _Metallic;
			o.Metallic = Metallic50;
			float2 uv_RoughnessTexture = i.uv_texcoord * _RoughnessTexture_ST.xy + _RoughnessTexture_ST.zw;
			float4 Smoothness44 = ( 1.0 - tex2D( _RoughnessTexture, uv_RoughnessTexture ) );
			o.Smoothness = Smoothness44.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;79;1562;652;980.7687;940.3522;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;42;282.9633,-1121.156;Inherit;False;1340.05;444.5964;Does not work;7;20;38;34;40;37;35;41;Local Vertex Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;20;332.9633,-1071.156;Inherit;True;Property;_VertexOffset;Vertex Offset;3;0;Create;True;0;0;0;False;0;False;-1;0a6a87a6c7a0d4743accb0f491428f6a;0a6a87a6c7a0d4743accb0f491428f6a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;48;-1404.22,-693.0042;Inherit;False;712.0328;241.3439;;3;44;43;21;Smoothness;1,1,1,1;0;0
Node;AmplifyShaderEditor.ParallaxMappingNode;34;682.353,-1038.72;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;38;573.3529,-883.7197;Inherit;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;24;-1403.441,-1144.3;Inherit;False;835.5123;410.2684;;4;32;22;16;14;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-511.1424,-798.8204;Inherit;False;713.3785;350.7236;;2;18;50;Metallic;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;32;-1322.898,-901.2285;Inherit;False;Property;_StoneColor;StoneColor;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2830187,0.2830187,0.2830187,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1349.441,-1094.3;Inherit;True;Property;_TextureAlbedo;Texture Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;fabdebbf4eecf1b4fba85239b753f02c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-1354.22,-643.0042;Inherit;True;Property;_RoughnessTexture;Roughness Texture;4;0;Create;True;0;0;0;False;0;False;-1;3076c523e7d01704584e504c3c7a82d9;3076c523e7d01704584e504c3c7a82d9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;765.3529,-791.7197;Inherit;False;Constant;_HeightController;HeightController;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;934.3528,-987.7197;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;27;-517.6051,-1125.91;Inherit;False;506.0805;240.9555;;2;25;15;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;43;-1052.487,-591.7347;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1003.828,-992.3234;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;-503.6046,-1083.954;Inherit;True;Property;_TextureNormals;Texture Normals;1;0;Create;True;0;0;0;False;0;False;-1;None;b23af15b7d6a3b148b706ff38d3a80ba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-386.5316,-658.2574;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;False;0;False;0;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;1148.353,-966.7197;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-796.1187,-992.2684;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;1378.353,-973.7197;Inherit;False;LocalVertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-201.7143,-1083.91;Inherit;False;Normals;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-890.8501,-596.616;Inherit;False;Smoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;21.04629,-668.9822;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-24.9187,378.2392;Inherit;False;35;LocalVertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-76.02344,219.4996;Inherit;False;44;Smoothness;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-105.7302,143.0778;Inherit;False;50;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;50.53635,25.05524;Inherit;False;22;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-106.3999,70.61661;Inherit;False;25;Normals;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;218.4,67.60001;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Rock;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;20;0
WireConnection;37;0;34;0
WireConnection;37;1;38;0
WireConnection;43;0;21;0
WireConnection;16;0;14;0
WireConnection;16;1;32;0
WireConnection;40;0;37;0
WireConnection;40;1;41;0
WireConnection;22;0;16;0
WireConnection;35;0;40;0
WireConnection;25;0;15;0
WireConnection;44;0;43;0
WireConnection;50;0;18;0
WireConnection;0;0;23;0
WireConnection;0;1;26;0
WireConnection;0;3;51;0
WireConnection;0;4;47;0
WireConnection;0;11;39;0
ASEEND*/
//CHKSM=9421B40946ABD2D46226E433E1D3DB803DFDBD1F