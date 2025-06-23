// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Silver"
{
	Properties
	{
		_Frequency("Frequency", Float) = 0
		_Speed("Speed", Float) = 0
		_FlashWidth("FlashWidth", Range( 0 , 0.1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Speed;
		uniform float _Frequency;
		uniform float _FlashWidth;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color1 = IsGammaSpace() ? float4(0.6792453,0.6792453,0.6792453,0) : float4(0.418999,0.418999,0.418999,0);
			o.Albedo = color1.rgb;
			float3 ase_worldPos = i.worldPos;
			float mulTime11 = _Time.y * _Speed;
			float LightFlash41 = (0.0 + (saturate( ( sin( ( ( ( ase_worldPos.x + ase_worldPos.y ) + mulTime11 ) * _Frequency ) ) - ( 1.0 - _FlashWidth ) ) ) - 0.0) * (1.0 - 0.0) / (_FlashWidth - 0.0));
			o.Emission = ( color1 * LightFlash41 ).rgb;
			o.Metallic = 1.0;
			o.Smoothness = 0.5;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;511;1488;483;2994.955;678.9443;2.898575;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-2532.635,344.3636;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;-2460.177,647.0732;Inherit;False;Property;_Speed;Speed;1;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2343.578,371.5899;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-2310.135,605.4277;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-2039.497,507.1275;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2033.009,747.5789;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1780.344,509.2194;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1764.178,756.0448;Inherit;False;Property;_FlashWidth;FlashWidth;2;0;Create;True;0;0;0;False;0;False;0;0.001;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;-1433.609,654.7899;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;9;-1637.702,507.0777;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-1243.958,493.7163;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;37;-960.6314,516.6785;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;39;-964.5516,781.3192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;-814.6314,538.6785;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-635.162,507.2988;Inherit;False;LightFlash;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-466.2983,-177.2916;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.6792453,0.6792453,0.6792453,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;40;-429.2746,46.80708;Inherit;False;41;LightFlash;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-404.7042,195.7479;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-392.3821,119.6907;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-228.4263,25.65337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,1;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Silver;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;15;1
WireConnection;16;1;15;2
WireConnection;11;0;22;0
WireConnection;14;0;16;0
WireConnection;14;1;11;0
WireConnection;19;0;14;0
WireConnection;19;1;18;0
WireConnection;34;0;35;0
WireConnection;9;0;19;0
WireConnection;33;0;9;0
WireConnection;33;1;34;0
WireConnection;37;0;33;0
WireConnection;39;0;35;0
WireConnection;38;0;37;0
WireConnection;38;2;39;0
WireConnection;41;0;38;0
WireConnection;42;0;1;0
WireConnection;42;1;40;0
WireConnection;0;0;1;0
WireConnection;0;2;42;0
WireConnection;0;3;4;0
WireConnection;0;4;5;0
ASEEND*/
//CHKSM=3EA6EE111B30B0BAEB4644C38EF0FDC8E7E1744E