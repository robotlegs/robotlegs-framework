//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	/**
	 * The Robotlegs log target contract
	 */
	public interface ILogTarget
	{
		/**
		 * Captures a log message
		 *
		 * @param source The source of the log message
		 * @param level The log level of the message
		 * @param timestamp getTimer() timestamp
		 * @param message The log message
		 * @param params Message parameters
		 */
		function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void;
	}
}
