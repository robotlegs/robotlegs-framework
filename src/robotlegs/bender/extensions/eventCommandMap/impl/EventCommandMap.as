//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandClassMapper;
	import robotlegs.bender.extensions.commandCenter.api.ICommandUnmapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.framework.api.IContext;

	/**
	 * @private
	 */
	public class EventCommandMap implements IEventCommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		private var _commandCenter:CommandCenter;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function EventCommandMap(context:IContext, dispatcher:IEventDispatcher)
		{
			_injector = context.injector;
			_dispatcher = dispatcher;
			_commandCenter = new CommandCenter(getKey, createTrigger)
				.withLogger(context.getLogger(this));
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function map(type:String, eventClass:Class = null):ICommandClassMapper
		{
			return _commandCenter.getMapper(type, eventClass) as ICommandClassMapper;
		}

		/**
		 * @inheritDoc
		 */
		public function unmap(type:String, eventClass:Class = null):ICommandUnmapper
		{
			return _commandCenter.getUnmapper(type, eventClass);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function getKey(type:String, eventClass:Class):String
		{
			return type + eventClass;
		}

		private function createTrigger(type:String, eventClass:Class):EventCommandTrigger
		{
			return new EventCommandTrigger(_injector, _dispatcher, type, eventClass);
		}
	}
}
