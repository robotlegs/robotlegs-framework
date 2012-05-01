//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{
	import org.hamcrest.Matcher;

	/**
	 * Object Processor
	 */
	public interface IObjectProcessor
	{
		/**
		 * Process an object.
		 * @param object The object instance to process.
		 */
		function processObject(object:Object):void;

		/**
		 * Add a handler to process objects that match a given matcher.
		 * @param matcher The matcher
		 * @param handler The handler function
		 */
		function addObjectHandler(matcher:Matcher, handler:Function):void;
	}
}
