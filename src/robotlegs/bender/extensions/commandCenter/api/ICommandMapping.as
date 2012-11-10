//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{

	public interface ICommandMapping
	{
		function get commandClass():Class;

		function get guards():Array;

		function get hooks():Array;

		function get fireOnce():Boolean;

		function get next():ICommandMapping;

		function set next(value:ICommandMapping):void;
	}
}
