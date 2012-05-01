//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	public interface ILogger
	{
		function debug(message:*, params:Array = null):void;
		function info(message:*, params:Array = null):void;
		function warn(message:*, params:Array = null):void;
		function error(message:*, params:Array = null):void;
		function fatal(message:*, params:Array = null):void;
	}
}
