//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
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

		// ss: this makes me sad :((((
		function validate():void;
		
		function get next():ICommandMapping;
		
		function set next(value:ICommandMapping):void;
	}
}
