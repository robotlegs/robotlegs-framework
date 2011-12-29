//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.api
{

	public interface IContextLogger
	{
		function debug(source:Object, message:*, parameters:Array = null):void;

		function info(source:Object, message:*, parameters:Array = null):void;

		function warn(source:Object, message:*, parameters:Array = null):void;

		function error(source:Object, message:*, parameters:Array = null):void;

		function fatal(source:Object, message:*, parameters:Array = null):void;

		function addTarget(target:IContextLogTarget):void;

		function removeTarget(target:IContextLogTarget):void;
	}
}
