//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.object.processor.impl
{
	import org.hamcrest.Matcher;

	public class ObjectHandlerBinding
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _matcher:Matcher;

		public function get matcher():Matcher
		{
			return _matcher;
		}

		private var _handler:Function;

		public function get handler():Function
		{
			return _handler;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ObjectHandlerBinding(matcher:Matcher, handler:Function)
		{
			_matcher = matcher;
			_handler = handler;
		}
	}
}
