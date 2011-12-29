//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging.api
{
	import robotlegs.bender.core.api.IContext;

	public interface IContextLogFormatter
	{
		function format(context:IContext, source:Object, level:uint, timestamp:int, message:*, parameters:Array = null):String;
	}
}
