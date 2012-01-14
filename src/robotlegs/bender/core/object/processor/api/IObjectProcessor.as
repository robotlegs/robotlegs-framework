//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.object.processor.api
{
	import org.hamcrest.Matcher;

	public interface IObjectProcessor extends Matcher
	{
		function addObject(object:Object, callback:Function = null):void;

		function addObjectHandler(matcher:Matcher, handler:Function):void;
	}
}
