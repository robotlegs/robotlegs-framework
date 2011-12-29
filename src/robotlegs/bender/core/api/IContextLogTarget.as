//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.api
{

	public interface IContextLogTarget
	{
		function log(context:IContext, source:Object, level:uint, timestamp:int, message:*, parameters:Array = null):void;
	}
}
