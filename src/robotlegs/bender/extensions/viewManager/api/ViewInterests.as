//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.api
{
	public class ViewInterests
	{

		public static const MISCELLANEOUS:uint = 1;
		// blocking isn't a valid response with none

		public static const MEDIATION:uint = 4;
		public static const MEDIATION_BLOCK:uint = 8;

		public static const INJECTION:uint = 16;
		public static const INJECTION_BLOCK:uint = 32;

		public static const SKINNING:uint = 64;
		public static const SKINNING_BLOCK:uint = 128;

		public static const LOCALISATION:uint = 256;
		public static const LOCALISATION_BLOCK:uint = 512;

		public static const LOGGING:uint = 1024;
		public static const LOGGING_BLOCK:uint = 2048;

		public static const PRESENTATION:uint = 4096;
		public static const PRESENTATION_BLOCK:uint = 8192;

		public static const ROBOTLEGS_8:uint = 16384;
		public static const ROBOTLEGS_8_BLOCK:uint = 32768;

		public static const CHANNEL_9:uint = 65536;
		public static const CHANNEL_9_BLOCK:uint = 131072;

		public static const CHANNEL_10:uint = 262144;
		public static const CHANNEL_10_BLOCK:uint = 524288;

		public static const CHANNEL_11:uint = 1048576;
		public static const CHANNEL_11_BLOCK:uint = 2097152;

		public static const CHANNEL_12:uint = 4194304;
		public static const CHANNEL_12_BLOCK:uint = 8388608;

		public static const CHANNEL_13:uint = 16777216;
		public static const CHANNEL_13_BLOCK:uint = 33554432;

		public static const CHANNEL_14:uint = 67108864;
		public static const CHANNEL_14_BLOCK:uint = 134217728;

		public static const CHANNEL_15:uint = 268435456;
		public static const CHANNEL_15_BLOCK:uint = 536870912;

		public static const CHANNEL_16:uint = 1073741824;
		public static const CHANNEL_16_BLOCK:uint = 2147483648;

	}
}
