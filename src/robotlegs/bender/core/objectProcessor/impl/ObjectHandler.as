//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.objectProcessor.impl
{
	import org.hamcrest.Matcher;
	import robotlegs.bender.core.objectProcessor.api.IObjectHandler;

	/**
	 * Default ObjectHandler implementation
	 */
	public class ObjectHandler implements IObjectHandler
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _matcher:Matcher;

		/**
		 * @inheritDoc
		 */
		public function get matcher():Matcher
		{
			return _matcher;
		}

		private var _closure:Function;

		/**
		 * @inheritDoc
		 */
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
