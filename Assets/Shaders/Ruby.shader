// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Rock"
{
	Properties
	{
		_Float1("Float 1", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		_Float2("Float 2", Float) = 0
		_Float4("Float 4", Range( 0 , 1)) = 0
		_Float3("Float 3", Float) = 1.48
		_Vector0("Vector 0", Vector) = (1,0,0,0)
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Float6("Float 6", Float) = 0
		_Float5("Float 5", Float) = 0.32
		_Float7("Float 7", Float) = 0
		_Float0("Float 0", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _TextureSample0;
		uniform float _Float2;
		uniform sampler2D _TextureSample2;
		uniform float _Float5;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float2 _Vector0;
		uniform float _Float4;
		uniform float _Float6;
		uniform float _Float7;
		uniform float _Float3;
		uniform float _Float1;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Float0;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord33 = i.uv_texcoord * float2( 3,3 );
			float3 tex2DNode28 = UnpackScaleNormal( tex2D( _TextureSample0, uv_TexCoord33 ), _Float2 );
			o.Normal = tex2DNode28;
			float2 uv_TexCoord58 = i.uv_texcoord * float2( 3,3 );
			float4 tex2DNode51 = tex2D( _TextureSample2, uv_TexCoord58 );
			float4 appendResult54 = (float4(tex2DNode51.r , tex2DNode51.g , tex2DNode51.b , 0.0));
			float grayscale53 = Luminance(appendResult54.xyz);
			float temp_output_60_0 = ( grayscale53 + _Float5 );
			float4 color57 = IsGammaSpace() ? float4(0.8773585,0,0,0) : float4(0.7433497,0,0,0);
			o.Albedo = ( ( temp_output_60_0 * temp_output_60_0 * temp_output_60_0 * temp_output_60_0 * temp_output_60_0 ) * color57 ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv_TexCoord47 = i.uv_texcoord * float2( 3,3 );
			float4 screenColor36 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + ( ( tex2D( _TextureSample0, uv_TexCoord47 ) - float4( _Vector0, 0.0 , 0.0 ) ) * _Float4 ) ).xy);
			float4 color19 = IsGammaSpace() ? float4(0.8679245,0.1514774,0.1514774,0) : float4(0.7254258,0.01994749,0.01994749,0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV22 = dot( (WorldNormalVector( i , tex2DNode28 )), ase_worldViewDir );
			float fresnelNode22 = ( 0.0 + _Float6 * pow( 1.0 - fresnelNdotV22, _Float7 ) );
			float4 color65 = IsGammaSpace() ? float4(1,0.2971698,0.2971698,0) : float4(1,0.07184544,0.07184544,0);
			o.Emission = saturate( ( saturate( ( screenColor36 * color19 ) ) + ( fresnelNode22 * color65 ) ) ).rgb;
			o.Metallic = _Float3;
			o.Smoothness = _Float1;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth66 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth66 = saturate( abs( ( screenDepth66 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Float0 ) ) );
			o.Alpha = distanceDepth66;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
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
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
0;802;1562;552;-409.9701;361.6837;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-567.7331,-406.0618;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;50;-199.0088,-235.6188;Inherit;False;Property;_Vector0;Vector 0;5;0;Create;True;0;0;0;False;0;False;1,0;1.02,-0.39;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;38;-322.0635,-425.0282;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;28;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;13.0518,-248.4479;Inherit;False;Property;_Float4;Float 4;3;0;Create;True;0;0;0;False;0;False;0;0.03450892;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;34.19696,-408.9072;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-253.2681,-893.8882;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;208.8085,-407.6917;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;35;-53.02872,-602.6243;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-1249.001,183.6245;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-1214.496,314.5835;Inherit;False;Property;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-15.19964,-922.0748;Inherit;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;0;False;0;False;-1;None;82bb282a7f76fec4381fd41f4f79a95e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;28;-1004.496,202.0834;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;c22c6e9f7090e0d48ba26107f8d35e52;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;45;394.1146,-490.0073;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-699.3369,123.6779;Inherit;False;Property;_Float7;Float 7;9;0;Create;True;0;0;0;False;0;False;0;8.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-723.3369,48.67787;Inherit;False;Property;_Float6;Float 6;7;0;Create;True;0;0;0;False;0;False;0;7.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;31;-850.1953,-143.0165;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;19;-461.8917,-156.9079;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.8679245,0.1514774,0.1514774,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;54;296.3078,-935.125;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;36;641.0234,-459.4065;Inherit;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;53;479.2901,-1069.186;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;668.697,-904.3069;Inherit;False;Property;_Float5;Float 5;8;0;Create;True;0;0;0;False;0;False;0.32;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;22;-520.8316,21.95185;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;65;-278.1115,92.86815;Inherit;False;Constant;_Color2;Color 2;9;0;Create;True;0;0;0;False;0;False;1,0.2971698,0.2971698,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-151.1399,-25.53164;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;689.5219,-1060.494;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;25;98.2228,-23.35003;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-9.987593,44.44045;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;406.9495,26.10386;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;917.4379,-1010.745;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;450.9434,-849.4637;Inherit;False;Constant;_Color1;Color 1;7;0;Create;True;0;0;0;False;0;False;0.8773585,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;975.2136,368.3283;Inherit;False;Property;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;1028.967,179.1079;Inherit;False;Property;_Float3;Float 3;4;0;Create;True;0;0;0;False;0;False;1.48;0.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;66;1166.791,329.5467;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;995.8754,248.0955;Inherit;False;Property;_Float1;Float 1;0;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;1166.753,-842.7422;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;68;1183.97,-26.68372;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1495.073,-155.4354;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Rock;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;1;47;0
WireConnection;48;0;38;0
WireConnection;48;1;50;0
WireConnection;46;0;48;0
WireConnection;46;1;41;0
WireConnection;51;1;58;0
WireConnection;28;1;33;0
WireConnection;28;5;29;0
WireConnection;45;0;35;0
WireConnection;45;1;46;0
WireConnection;31;0;28;0
WireConnection;54;0;51;1
WireConnection;54;1;51;2
WireConnection;54;2;51;3
WireConnection;36;0;45;0
WireConnection;53;0;54;0
WireConnection;22;0;31;0
WireConnection;22;2;62;0
WireConnection;22;3;63;0
WireConnection;37;0;36;0
WireConnection;37;1;19;0
WireConnection;60;0;53;0
WireConnection;60;1;61;0
WireConnection;25;0;37;0
WireConnection;64;0;22;0
WireConnection;64;1;65;0
WireConnection;24;0;25;0
WireConnection;24;1;64;0
WireConnection;59;0;60;0
WireConnection;59;1;60;0
WireConnection;59;2;60;0
WireConnection;59;3;60;0
WireConnection;59;4;60;0
WireConnection;66;0;67;0
WireConnection;55;0;59;0
WireConnection;55;1;57;0
WireConnection;68;0;24;0
WireConnection;0;0;55;0
WireConnection;0;1;28;0
WireConnection;0;2;68;0
WireConnection;0;3;34;0
WireConnection;0;4;26;0
WireConnection;0;9;66;0
ASEEND*/
//CHKSM=C17C6B773E80F60DC78E775846436E56225ECACF