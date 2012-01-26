//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.objectProcessor.api
{
	import org.hamcrest.Matcher;

	/**
	 * Object handler Value Object
	 */
	public interface IObjectHandler
	{
		/**
		 * @return Matcher
		 */
		function get matcher():Matcher;

		/**
		 * @return Handler function
		 */
		function get closure():Function;
	}
}
