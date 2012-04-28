//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.objectProcessor.impl
{
	import org.hamcrest.Matcher;
	import robotlegs.bender.core.objectProcessor.api.IObjectProcessor;

	/**
	 * Default IObjectProcessor implementation.
	 */
	public class ObjectProcessor implements IObjectProcessor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _handlers:Array = [];

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function addObjectHandler(matcher:Matcher, handler:Function):void
		{
			_handlers.push(new ObjectHandler(matcher, handler));
		}

		/**
		 * @inheritDoc
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
