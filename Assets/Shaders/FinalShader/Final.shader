// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Final"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Noise("Noise", 2D) = "white" {}
		_Distortionmap("Distortion map", 2D) = "bump" {}
		_DistortionAmount("Distortion Amount", Range( 0 , 1)) = 1
		_ScrollSpeed("ScrollSpeed", Range( 0 , 1)) = 0
		_Burn("Burn", Range( 0 , 1)) = 0.3411765
		_HeatWave("Heat Wave", Range( 0 , 1)) = 0
		_Wiggle("Wiggle", Range( -0.01 , 0.01)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _Distortionmap;
		uniform float _ScrollSpeed;
		uniform sampler2D _Noise;
		uniform float _HeatWave;
		uniform float _Burn;
		uniform float _Wiggle;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Distortionmap_ST;
		uniform float _DistortionAmount;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float Time65 = ( _Time.y * _ScrollSpeed );
			float2 panner52 = ( Time65 * float2( 0,-1 ) + v.texcoord.xy);
			float3 tex2DNode48 = UnpackNormal( tex2Dlod( _Distortionmap, float4( panner52, 0, 0.0) ) );
			float3 DistMove71 = tex2DNode48;
			float4 tex2DNode31 = tex2Dlod( _Noise, float4( ( ( (tex2DNode48).xy * _HeatWave ) + v.texcoord.xy ), 0, 0.0) );
			float temp_output_33_0 = step( tex2DNode31.r , _Burn );
			float FirstStep77 = temp_output_33_0;
			float3 Vertex81 = ( ( ( ase_worldPos * ase_vertex3Pos ) * DistMove71 * FirstStep77 ) * _Wiggle );
			v.vertex.xyz += Vertex81;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float4 color23 = IsGammaSpace() ? float4(1,0.5280088,0,0) : float4(1,0.2408876,0,0);
			float4 color24 = IsGammaSpace() ? float4(1,0.8855017,0,0) : float4(1,0.7590269,0,0);
			float2 uv_Distortionmap = i.uv_texcoord * _Distortionmap_ST.xy + _Distortionmap_ST.zw;
			float Time65 = ( _Time.y * _ScrollSpeed );
			float2 panner15 = ( Time65 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord13 = i.uv_texcoord + panner15;
			float4 lerpResult25 = lerp( color23 , color24 , tex2D( _Noise, ( ( (UnpackNormal( tex2D( _Distortionmap, uv_Distortionmap ) )).xy * _DistortionAmount ) + uv_TexCoord13 ) ));
			float4 temp_cast_1 = (1.0).xxxx;
			float2 panner52 = ( Time65 * float2( 0,-1 ) + i.uv_texcoord);
			float3 tex2DNode48 = UnpackNormal( tex2D( _Distortionmap, panner52 ) );
			float4 tex2DNode31 = tex2D( _Noise, ( ( (tex2DNode48).xy * _HeatWave ) + i.uv_texcoord ) );
			float temp_output_33_0 = step( tex2DNode31.r , _Burn );
			o.Emission = ( ( pow( lerpResult25 , temp_cast_1 ) * 1.0 ) * ( temp_output_33_0 + ( temp_output_33_0 - step( tex2DNode31.r , ( _Burn / 1.05 ) ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;651;1562;703;364.8274;1017.994;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;17;-2323.965,-1098.36;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2451.086,-1015.071;Inherit;False;Property;_ScrollSpeed;ScrollSpeed;5;0;Create;True;0;0;0;False;0;False;0;0.07;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2145.4,-1093.795;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;65;-2007.839,-1101.338;Inherit;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;7;-2215.538,-1289.513;Inherit;True;Property;_Distortionmap;Distortion map;3;0;Create;True;0;0;0;False;0;False;f6099fef2b2bbab4f8922855d32d3ddf;f6099fef2b2bbab4f8922855d32d3ddf;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1986.017,-1288.941;Inherit;False;DistortionMap;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2278.691,681.0433;Inherit;False;65;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-2276.404,566.5251;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;52;-2055.751,578.8275;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2052.262,480.6068;Inherit;False;62;DistortionMap;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;48;-1824.753,455.1773;Inherit;True;Property;_TextureSample3;Texture Sample 3;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;54;-1527.433,453.8737;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1813.432,647.8738;Inherit;False;Property;_HeatWave;Heat Wave;7;0;Create;True;0;0;0;False;0;False;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1641.786,-1303.197;Inherit;True;Property;_Noise;Noise;2;0;Create;True;0;0;0;False;0;False;65c0239de4be12842ba5410bb25eaccc;65c0239de4be12842ba5410bb25eaccc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-1402.688,-1299.483;Inherit;False;Mask;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2416.088,-98.07794;Inherit;False;62;DistortionMap;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1266.432,524.8736;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-1378.475,640.6139;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1122.601,450.0097;Inherit;False;68;Mask;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;8;-2228.662,-96.33647;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1127.475,530.6138;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-2313.23,216.0741;Inherit;False;65;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;10;-1942.76,-94.06738;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;15;-2111.192,177.0647;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-900.6458,662.1395;Inherit;False;Property;_Burn;Burn;6;0;Create;True;0;0;0;False;0;False;0.3411765;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-901.0186,469.4552;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-2208.76,89.93262;Inherit;False;Property;_DistortionAmount;Distortion Amount;4;0;Create;True;0;0;0;False;0;False;1;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-1854.613,94.02394;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;33;-433.8321,503.0393;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1743.76,-86.06738;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1602.059,-86.707;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-1650.765,-166.1742;Inherit;False;68;Mask;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-781.5877,739.0278;Inherit;False;Constant;_Beach;Beach;7;0;Create;True;0;0;0;False;0;False;1.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-260.6892,341.7965;Inherit;False;FirstStep;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;73;545.9221,376.2256;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-1516.653,347.511;Inherit;False;DistMove;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;72;549.173,218.0132;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;44;-562.1809,688.2579;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;552.4243,517.0998;Inherit;False;71;DistMove;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;547.8325,599.2087;Inherit;False;77;FirstStep;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-1368.506,-464.3866;Inherit;False;Constant;_Warm;Warm;4;0;Create;True;0;0;0;False;0;False;1,0.5280088,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;24;-1367.506,-288.3182;Inherit;False;Constant;_Hot;Hot;4;0;Create;True;0;0;0;False;0;False;1,0.8855017,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;740.9786,289.5338;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;5;-1450.855,-109.7351;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;901.3588,352.3853;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;43;-434.3534,599.2243;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1056.194,-181.8069;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;-1063.606,-311.6288;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;79;907.8325,517.2087;Inherit;False;Property;_Wiggle;Wiggle;8;0;Create;True;0;0;0;False;0;False;0;-0.001;-0.01;0.01;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;46;-295.0054,559.2325;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;28;-875.6426,-307.0354;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;1126.833,416.2087;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-149.4346,437.8703;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;1286.211,410.4092;Inherit;False;Vertex;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-652.4142,-307.9128;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-26.94244,-53.4632;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;660.2107,-145.5908;Inherit;False;81;Vertex;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;40;291.2067,-985.9146;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;7cfb5ab3032e1264994ef71655052a61;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;83;286.1952,-795.043;Inherit;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;0;False;0;False;-1;a379ff2fc78316c468ac0ac03256d77f;a379ff2fc78316c468ac0ac03256d77f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;875.2202,-420.993;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Final;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;65;0;18;0
WireConnection;62;0;7;0
WireConnection;52;0;53;0
WireConnection;52;1;67;0
WireConnection;48;0;64;0
WireConnection;48;1;52;0
WireConnection;54;0;48;0
WireConnection;68;0;4;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;8;0;63;0
WireConnection;58;0;55;0
WireConnection;58;1;57;0
WireConnection;10;0;8;0
WireConnection;15;1;66;0
WireConnection;31;0;70;0
WireConnection;31;1;58;0
WireConnection;13;1;15;0
WireConnection;33;0;31;1
WireConnection;33;1;34;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;14;0;11;0
WireConnection;14;1;13;0
WireConnection;77;0;33;0
WireConnection;71;0;48;0
WireConnection;44;0;34;0
WireConnection;44;1;45;0
WireConnection;74;0;72;0
WireConnection;74;1;73;0
WireConnection;5;0;69;0
WireConnection;5;1;14;0
WireConnection;75;0;74;0
WireConnection;75;1;76;0
WireConnection;75;2;78;0
WireConnection;43;0;31;1
WireConnection;43;1;44;0
WireConnection;25;0;23;0
WireConnection;25;1;24;0
WireConnection;25;2;5;0
WireConnection;46;0;33;0
WireConnection;46;1;43;0
WireConnection;28;0;25;0
WireConnection;28;1;29;0
WireConnection;80;0;75;0
WireConnection;80;1;79;0
WireConnection;47;0;33;0
WireConnection;47;1;46;0
WireConnection;81;0;80;0
WireConnection;30;0;28;0
WireConnection;30;1;29;0
WireConnection;35;0;30;0
WireConnection;35;1;47;0
WireConnection;0;0;40;0
WireConnection;0;1;83;0
WireConnection;0;2;35;0
WireConnection;0;11;82;0
ASEEND*/
//CHKSM=E2F16B3ADE0C4391D512A6E784AFBA3A40141ACD