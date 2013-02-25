//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import robotlegs.bender.framework.api.IMatcher;

	/**
	 * Robotlegs object processor
	 *
	 * @private
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
		public function addObjectHandler(matcher:IMatcher, handler:Function):void
		{
			_handlers.push(new ObjectHandler(matcher, handler));
		}

		/**
		 * Process an object by running it through all registered handlers
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

import robotlegs.bender.framework.api.IMatcher;

class ObjectHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _matcher:IMatcher;

	private var _handler:Function;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function ObjectHandler(matcher:IMatcher, handler:Function)
	{
		_matcher = matcher;
		_handler = handler;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function handle(object:Object):void
	{
		_matcher.matches(object) && _handler(object);
	}
}
