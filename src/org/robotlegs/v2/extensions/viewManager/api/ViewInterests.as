//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager.api
{
	public class ViewInterests
	{

		public static const NONE:uint = 0x1;
		// blocking isn't a valid response with none
		public static const MEDIATION:uint = 0x4;
		public static const MEDIATION_BLOCK:uint = 0x8;
		public static const INJECTION:uint = 0x16;
		public static const INJECTION_BLOCK:uint = 0x32;
		public static const SKINNING:uint = 0x64;
		public static const SKINNING_BLOCK:uint = 0x128;
		public static const LOCALISATION:uint = 0x256;
		public static const LOCALISATION_BLOCK:uint = 0x512;
		public static const LOGGING:uint = 0x1024;
		public static const LOGGING_BLOCK:uint = 0x2048;
		public static const PRESENTATION:uint = 0x4096;
		public static const PRESENTATION_BLOCK:uint = 0x8192;
	}
}
