// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Ruby"
{
	Properties
	{
		_Roughness("Roughness", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		_NormalIntensity("NormalIntensity", Float) = 0
		_DistortionIntensity("DistortionIntensity", Range( 0 , 1)) = 0
		_Metallic("Metallic", Float) = 1.48
		_DistortionDirection("DistortionDirection", Vector) = (1,0,0,0)
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_FresnelScale("FresnelScale", Float) = 0
		_ColorIntensity("ColorIntensity", Float) = 0.32
		_FresnelPower("FresnelPower", Float) = 0
		_DepthFadeDistance("DepthFadeDistance", Float) = 0
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
		uniform float _NormalIntensity;
		uniform sampler2D _TextureSample2;
		uniform float _ColorIntensity;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float2 _DistortionDirection;
		uniform float _DistortionIntensity;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _Metallic;
		uniform float _Roughness;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeDistance;


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
			float3 Normal70 = UnpackScaleNormal( tex2D( _TextureSample0, uv_TexCoord33 ), _NormalIntensity );
			o.Normal = Normal70;
			float2 uv_TexCoord58 = i.uv_texcoord * float2( 3,3 );
			float4 tex2DNode51 = tex2D( _TextureSample2, uv_TexCoord58 );
			float4 appendResult54 = (float4(tex2DNode51.r , tex2DNode51.g , tex2DNode51.b , 0.0));
			float grayscale53 = Luminance(appendResult54.xyz);
			float temp_output_60_0 = ( grayscale53 + _ColorIntensity );
			float4 color57 = IsGammaSpace() ? float4(0.8773585,0,0,0) : float4(0.7433497,0,0,0);
			float4 Albedo79 = ( ( temp_output_60_0 * temp_output_60_0 * temp_output_60_0 * temp_output_60_0 * temp_output_60_0 ) * color57 );
			o.Albedo = Albedo79.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv_TexCoord47 = i.uv_texcoord * float2( 3,3 );
			float4 Distortion81 = ( ase_grabScreenPosNorm + ( ( tex2D( _TextureSample0, uv_TexCoord47 ) - float4( _DistortionDirection, 0.0 , 0.0 ) ) * _DistortionIntensity ) );
			float4 screenColor36 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,Distortion81.xy);
			float4 color19 = IsGammaSpace() ? float4(0.8679245,0.1514774,0.1514774,0) : float4(0.7254258,0.01994749,0.01994749,0);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV22 = dot( (WorldNormalVector( i , Normal70 )), ase_worldViewDir );
			float fresnelNode22 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV22, _FresnelPower ) );
			float4 color65 = IsGammaSpace() ? float4(1,0.2971698,0.2971698,0) : float4(1,0.07184544,0.07184544,0);
			float4 Emission75 = saturate( ( saturate( ( screenColor36 * color19 ) ) + ( fresnelNode22 * color65 ) ) );
			o.Emission = Emission75.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Roughness;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth66 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth66 = saturate( abs( ( screenDepth66 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) ) );
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
-1920;23;1920;991;1237.117;1353.983;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;84;-1143.308,-681.054;Inherit;False;1379.132;578.4859;Distortion;9;47;50;38;48;46;35;45;41;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-1079.308,-425.0542;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;50;-711.3084,-265.0542;Inherit;False;Property;_DistortionDirection;DistortionDirection;5;0;Create;True;0;0;0;False;0;False;1,0;1,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;38;-839.3084,-457.0542;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;28;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-487.3087,-441.0542;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;85;-1144.41,604.0374;Inherit;False;890.7653;298.4589;Normal;4;33;29;28;70;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-503.3087,-281.0542;Inherit;False;Property;_DistortionIntensity;DistortionIntensity;3;0;Create;True;0;0;0;False;0;False;0;0.035;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1059.905,784.9964;Inherit;False;Property;_NormalIntensity;NormalIntensity;2;0;Create;True;0;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;35;-567.3084,-633.054;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-1094.41,654.0374;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-311.3084,-441.0542;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-119.3084,-521.0542;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;80;-1143.308,-1161.054;Inherit;False;1847.995;458.1527;Albedo;10;53;60;54;51;58;61;59;55;57;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;28;-849.9048,672.4963;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;c22c6e9f7090e0d48ba26107f8d35e52;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;83;-1143.308,-89.05417;Inherit;False;1707.031;670.6583;Emission;15;64;62;22;31;63;65;25;37;19;36;24;68;75;82;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;58;-1095.308,-1081.054;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;8.691596,-489.0542;Inherit;False;Distortion;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-481.8351,670.7149;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;51;-855.3084,-1113.054;Inherit;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;0;False;0;False;-1;None;82bb282a7f76fec4381fd41f4f79a95e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;82;-807.3084,-41.05416;Inherit;False;81;Distortion;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-1095.308,198.9458;Inherit;False;70;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-887.3083,406.9458;Inherit;False;Property;_FresnelPower;FresnelPower;9;0;Create;True;0;0;0;False;0;False;0;8.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;36;-631.3084,-41.05416;Inherit;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-887.3083,342.9458;Inherit;False;Property;_FresnelScale;FresnelScale;7;0;Create;True;0;0;0;False;0;False;0;7.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;54;-551.3085,-1081.054;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;19;-679.3084,134.9458;Inherit;False;Constant;_Color0;Color 0;0;0;Create;True;0;0;0;False;0;False;0.8679245,0.1514774,0.1514774,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;31;-919.3083,198.9458;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;65;-455.3087,374.9458;Inherit;False;Constant;_Color2;Color 2;9;0;Create;True;0;0;0;False;0;False;1,0.2971698,0.2971698,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-359.3085,-873.054;Inherit;False;Property;_ColorIntensity;ColorIntensity;8;0;Create;True;0;0;0;False;0;False;0.32;0.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-279.3084,198.9458;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FresnelNode;22;-679.3084,310.9458;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;53;-375.3086,-1097.054;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-135.3084,310.9458;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;25;-135.3084,198.9458;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-167.3084,-1081.054;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;24.6916,-921.054;Inherit;False;Constant;_Color1;Color 1;7;0;Create;True;0;0;0;False;0;False;0.8773585,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;24.6916,246.9458;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;40.69158,-1081.054;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;68;200.6916,246.9458;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;264.6915,-1081.054;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;488.6917,-1081.054;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;344.6915,230.9458;Inherit;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;67;916.9355,217.2807;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;10;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;1204.011,112.5095;Inherit;False;Property;_Roughness;Roughness;0;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;1191.698,-130.1239;Inherit;False;70;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;1191.956,-228.3411;Inherit;False;79;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;1192.092,-40.84288;Inherit;False;75;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;1207.368,39.95378;Inherit;False;Property;_Metallic;Metallic;4;0;Create;True;0;0;0;False;0;False;1.48;0.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;66;1119.218,198.7182;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1495.073,-155.4354;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Ruby;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;1;47;0
WireConnection;48;0;38;0
WireConnection;48;1;50;0
WireConnection;46;0;48;0
WireConnection;46;1;41;0
WireConnection;45;0;35;0
WireConnection;45;1;46;0
WireConnection;28;1;33;0
WireConnection;28;5;29;0
WireConnection;81;0;45;0
WireConnection;70;0;28;0
WireConnection;51;1;58;0
WireConnection;36;0;82;0
WireConnection;54;0;51;1
WireConnection;54;1;51;2
WireConnection;54;2;51;3
WireConnection;31;0;71;0
WireConnection;37;0;36;0
WireConnection;37;1;19;0
WireConnection;22;0;31;0
WireConnection;22;2;62;0
WireConnection;22;3;63;0
WireConnection;53;0;54;0
WireConnection;64;0;22;0
WireConnection;64;1;65;0
WireConnection;25;0;37;0
WireConnection;60;0;53;0
WireConnection;60;1;61;0
WireConnection;24;0;25;0
WireConnection;24;1;64;0
WireConnection;59;0;60;0
WireConnection;59;1;60;0
WireConnection;59;2;60;0
WireConnection;59;3;60;0
WireConnection;59;4;60;0
WireConnection;68;0;24;0
WireConnection;55;0;59;0
WireConnection;55;1;57;0
WireConnection;79;0;55;0
WireConnection;75;0;68;0
WireConnection;66;0;67;0
WireConnection;0;0;78;0
WireConnection;0;1;69;0
WireConnection;0;2;76;0
WireConnection;0;3;34;0
WireConnection;0;4;26;0
WireConnection;0;9;66;0
ASEEND*/
//CHKSM=320F4C0E891F2AB0C3E8B30643E29E7026C3EDF8