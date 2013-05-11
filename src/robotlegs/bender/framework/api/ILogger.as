//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	/**
	 * The Robotlegs logger contract
	 */
	public interface ILogger
	{
		/**
		 * Logs a message for debug purposes
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function debug(message:*, params:Array = null):void;

		/**
		 * Logs a message for notification purposes
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function info(message:*, params:Array = null):void;

		/**
		 * Logs a warning message
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function warn(message:*, params:Array = null):void;

		/**
		 * Logs an error message
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function error(message:*, params:Array = null):void;

		/**
		 * Logs a fatal error message
		 * @param message Message to log
		 * @param params Message parameters
		 */
		function fatal(message:*, params:Array = null):void;
	}
}
