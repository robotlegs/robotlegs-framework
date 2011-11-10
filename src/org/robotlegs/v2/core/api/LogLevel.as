//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.api
{
	import flash.utils.Dictionary;

	public class LogLevel
	{
		public static const NONE:uint = 0;

		public static const FATAL:uint = 2;

		public static const ERROR:uint = 4;

		public static const WARN:uint = 8;

		public static const INFO:uint = 16;

		public static const DEBUG:uint = 32;

		private static const names:Dictionary = createNames();

		public static function getName(level:uint):String
		{
			return names[level];
		}

		private static function createNames():Dictionary
		{
			const hash:Dictionary = new Dictionary();
			hash[NONE] = 'NONE';
			hash[FATAL] = 'FATAL';
			hash[ERROR] = 'ERROR';
			hash[WARN] = 'WARN';
			hash[INFO] = 'INFO';
			hash[DEBUG] = 'DEBUG';
			return hash;
		}
	}
}
