// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Silver"
{
	Properties
	{
		_Frequency("Frequency", Float) = 0
		_Speed("Speed", Float) = 0
		_FlashWidth("FlashWidth", Range( 0 , 0.1)) = 0
		_noisybackground("noisy-background", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _noisybackground;
		uniform float4 _noisybackground_ST;
		uniform float _Speed;
		uniform float _Frequency;
		uniform float _FlashWidth;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color1 = IsGammaSpace() ? float4(0.6792453,0.6792453,0.6792453,0) : float4(0.418999,0.418999,0.418999,0);
			float2 uv_noisybackground = i.uv_texcoord * _noisybackground_ST.xy + _noisybackground_ST.zw;
			float4 Albedo46 = ( color1 * tex2D( _noisybackground, uv_noisybackground ) );
			o.Albedo = Albedo46.rgb;
			float3 ase_worldPos = i.worldPos;
			float mulTime11 = _Time.y * _Speed;
			float LightFlash41 = (0.0 + (saturate( ( sin( ( ( ( ase_worldPos.x + ase_worldPos.y ) + mulTime11 ) * _Frequency ) ) - ( 1.0 - _FlashWidth ) ) ) - 0.0) * (1.0 - 0.0) / (_FlashWidth - 0.0));
			o.Emission = ( Albedo46 * LightFlash41 ).rgb;
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
0;23;1920;991;2400.901;605.4778;1.472003;True;False
Node;AmplifyShaderEditor.CommentaryNode;45;-2520.096,457.2988;Inherit;False;2113.125;397.735;LightFlash;15;37;41;34;33;11;22;9;19;14;18;16;15;39;35;38;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;15;-2470.096,515.8444;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;-2403.691,739.8738;Inherit;False;Property;_Speed;Speed;1;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2274.987,516.8444;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;11;-2245.579,744.6286;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1940.207,735.4747;Inherit;False;Property;_Frequency;Frequency;0;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1993.096,517.2147;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1689.532,737.8883;Inherit;False;Property;_FlashWidth;FlashWidth;2;0;Create;True;0;0;0;False;0;False;0;0.001;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1735.96,519.3066;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;-1385.191,676.9814;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;9;-1585.249,519.1823;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1682.036,-197.8648;Inherit;False;884.352;448.6962;Albedo Texture;4;43;1;44;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-1195.54,515.9079;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;39;-1025.074,724.8319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;37;-960.6314,516.6785;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-1632.036,20.83135;Inherit;True;Property;_noisybackground;noisy-background;3;0;Create;True;0;0;0;False;0;False;-1;a82d00e497d6dae41be1efbe68cab6d3;a82d00e497d6dae41be1efbe68cab6d3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-1577.913,-147.8648;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.6792453,0.6792453,0.6792453,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1270.217,-116.5711;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;-814.6314,516.4872;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-635.162,507.2988;Inherit;False;LightFlash;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-1025.874,-74.18498;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-534.7546,96.03125;Inherit;False;41;LightFlash;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-530.2126,21.29537;Inherit;False;46;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-282.8163,191.0599;Inherit;False;Constant;_Roughness;Roughness;1;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-271.666,116.1747;Inherit;False;Constant;_Metallic;Metallic;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-271.7902,26.82537;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-309.8761,-47.85273;Inherit;False;46;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4.688012,-48.22415;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Silver;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
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
WireConnection;39;0;35;0
WireConnection;37;0;33;0
WireConnection;44;0;1;0
WireConnection;44;1;43;0
WireConnection;38;0;37;0
WireConnection;38;2;39;0
WireConnection;41;0;38;0
WireConnection;46;0;44;0
WireConnection;42;0;49;0
WireConnection;42;1;40;0
WireConnection;0;0;48;0
WireConnection;0;2;42;0
WireConnection;0;3;4;0
WireConnection;0;4;5;0
ASEEND*/
//CHKSM=FB12880CB446070089A598A07DC34D6B64C222D2