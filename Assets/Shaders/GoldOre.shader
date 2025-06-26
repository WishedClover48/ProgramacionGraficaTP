// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Gold"
{
	Properties
	{
		_Float0("Float 0", Float) = 5.68
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Float2("Float 2", Float) = 0
		_Float1("Float 1", Range( 0 , 1)) = 0
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

		uniform float _Float0;
		uniform float _Float2;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Float1;


		float2 voronoihash30( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi30( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash30( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.707 * sqrt(dot( r, r ));
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F2;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color12 = IsGammaSpace() ? float4(1,0.5882353,0,0) : float4(1,0.3049874,0,0);
			float time30 = 0.0;
			float2 coords30 = i.uv_texcoord * _Float0;
			float2 id30 = 0;
			float2 uv30 = 0;
			float fade30 = 0.5;
			float voroi30 = 0;
			float rest30 = 0;
			for( int it30 = 0; it30 <6; it30++ ){
			voroi30 += fade30 * voronoi30( coords30, time30, id30, uv30, 0 );
			rest30 += fade30;
			coords30 *= 2;
			fade30 *= 0.5;
			}//Voronoi30
			voroi30 /= rest30;
			float Noise67 = saturate( (_Float2 + (voroi30 - 0.0) * (2.0 - _Float2) / (1.0 - 0.0)) );
			float4 GoldPos63 = ( color12 * Noise67 );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 RockPos72 = ( saturate( ( 1.0 - ( ( distance( float3( 0,0,0 ) , GoldPos63.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ) * tex2D( _TextureSample0, uv_TextureSample0 ) * _Float1 );
			o.Albedo = ( RockPos72 + GoldPos63 ).rgb;
			float lerpResult15 = lerp( 0.8 , 1.0 , Noise67);
			o.Metallic = lerpResult15;
			float lerpResult76 = lerp( 0.1 , 1.0 , Noise67);
			o.Smoothness = lerpResult76;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
-1920;23;1920;991;1964.87;387.7195;1.312107;True;False
Node;AmplifyShaderEditor.CommentaryNode;77;-2340.338,223.3856;Inherit;False;1187.727;360.8428;Gold mask;7;31;40;30;42;38;39;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2264.15,429.4844;Inherit;False;Property;_Float0;Float 0;0;0;Create;True;0;0;0;False;0;False;5.68;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-2290.338,273.3856;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-2064.731,469.0684;Inherit;False;Property;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;0;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;30;-2061.717,299.7858;Inherit;False;0;1;1;1;6;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCRemapNode;38;-1879.648,309.1682;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-1583.749,308.7301;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;78;-2106.675,-195.5455;Inherit;False;857.9551;376.3193;Gold position;4;71;12;10;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-1380.801,326.7826;Inherit;False;Noise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-2056.675,-145.5455;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;1,0.5882353,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;71;-2023.005,65.61379;Inherit;False;67;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1740.797,-106.585;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;79;-2279.226,-858.2988;Inherit;False;1016.073;590.3871;Rock position;6;66;43;57;62;58;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;63;-1476.91,-111.2521;Inherit;False;GoldPos;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-2229.226,-789.6589;Inherit;False;63;GoldPos;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;43;-2084.24,-578.4799;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;0a6a87a6c7a0d4743accb0f491428f6a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;57;-2013.694,-808.2988;Inherit;True;Color Mask;-1;;2;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-2071.558,-383.0717;Inherit;False;Property;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-1731.795,-600.3992;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-1491.343,-563.926;Inherit;False;RockPos;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-551.2871,27.79498;Inherit;False;72;RockPos;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-601.1849,313.7823;Inherit;False;67;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-553.9788,132.4997;Inherit;False;63;GoldPos;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-604.0802,534.2234;Inherit;False;67;Noise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;76;-386.6545,472.8363;Inherit;True;3;0;FLOAT;0.1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;15;-383.7592,252.3952;Inherit;True;3;0;FLOAT;0.8;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;-359.582,33.74225;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1,1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Gold;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;40;0
WireConnection;30;2;31;0
WireConnection;38;0;30;0
WireConnection;38;3;42;0
WireConnection;39;0;38;0
WireConnection;67;0;39;0
WireConnection;10;0;12;0
WireConnection;10;1;71;0
WireConnection;63;0;10;0
WireConnection;57;1;66;0
WireConnection;58;0;57;0
WireConnection;58;1;43;0
WireConnection;58;2;62;0
WireConnection;72;0;58;0
WireConnection;76;2;75;0
WireConnection;15;2;68;0
WireConnection;59;0;73;0
WireConnection;59;1;64;0
WireConnection;0;0;59;0
WireConnection;0;3;15;0
WireConnection;0;4;76;0
ASEEND*/
//CHKSM=0F23C00D300C005721E67DF62086F65352B104D1