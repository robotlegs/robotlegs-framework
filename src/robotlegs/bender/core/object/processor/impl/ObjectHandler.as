//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.object.processor.impl
{
	import org.hamcrest.Matcher;
	import robotlegs.bender.core.object.processor.api.IObjectHandler;

	public class ObjectHandler implements IObjectHandler
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _matcher:Matcher;

		public function get matcher():Matcher
		{
			return _matcher;
		}

		private var _closure:Function;

		public function get closure():Function
		{
			return _closure;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ObjectHandler(matcher:Matcher, closure:Function)
		{
			_matcher = matcher;
			_closure = closure;
		}
	}
}
