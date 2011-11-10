//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.api
{

	public interface ILogger
	{
		function get target():ILogTarget;

		function set target(value:ILogTarget):void;

		function debug(message:*, parameters:Array = null):void;

		function info(message:*, parameters:Array = null):void;

		function warn(message:*, parameters:Array = null):void;

		function error(message:*, parameters:Array = null):void;

		function fatal(message:*, parameters:Array = null):void;
	}
}
