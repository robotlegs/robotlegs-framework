//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.hamcrest.Matcher;

	/**
	 * Robotlegs object processor
	 */
	public class ObjectProcessor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _handlers:Array = [];

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * Add a handler to process objects that match a given matcher.
		 * @param matcher The matcher
		 * @param handler The handler function
		 */
		public function addObjectHandler(matcher:Matcher, handler:Function):void
		{
			_handlers.push(new ObjectHandler(matcher, handler));
		}

		/**
		 * Process an object by running it through registered handlers
		 * @param object The object instance to process.
		 */
		public function processObject(object:Object):void
		{
			for each (var handler:ObjectHandler in _handlers)
			{
				handler.handle(object);
			}
		}
	}
}

import org.hamcrest.Matcher;

class ObjectHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _matcher:Matcher;

	private var _handler:Function;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function ObjectHandler(matcher:Matcher, handler:Function)
	{
		_matcher = matcher;
		_handler = handler;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function handle(object:Object):void
	{
		_matcher.matches(object) && _handler(object);
	}
}
