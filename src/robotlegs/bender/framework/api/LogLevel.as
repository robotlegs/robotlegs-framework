//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	/**
	 * Robotlegs log level
	 */
	public class LogLevel
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const FATAL:uint = 2;

		public static const ERROR:uint = 4;

		public static const WARN:uint = 8;

		public static const INFO:uint = 16;

		public static const DEBUG:uint = 32;

		public static const NAME:Array = [
			0, 0, 'FATAL', // 2
			0, 'ERROR', // 4
			0, 0, 0, 'WARN', // 8
			0, 0, 0, 0, 0, 0, 0, 'INFO', // 16
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'DEBUG']; // 32
	}
}
