//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.impl.CommandExecutor;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.CommandPayload;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * @private
	 */
	public class EventCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _eventClass:Class;

		private var _mappings:ICommandMappingList;

		private var _executor:ICommandExecutor;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function EventCommandTrigger(
			injector:IInjector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class = null,
			processors:Array = null,
			logger:ILogger = null)
		{
			_dispatcher = dispatcher;
			_type = type;
			_eventClass = eventClass;
			_mappings = new CommandMappingList(this, processors, logger);
			_executor = new CommandExecutor(injector, _mappings.removeMapping);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function createMapper():CommandMapper
		{
			return new CommandMapper(_mappings);
		}

		/**
		 * @inheritDoc
		 */
		public function activate():void
		{
			_dispatcher.addEventListener(_type, eventHandler);
		}

		/**
		 * @inheritDoc
		 */
		public function deactivate():void
		{
			_dispatcher.removeEventListener(_type, eventHandler);
		}

		public function toString():String
		{
			return _eventClass + " with selector '" + _type + "'";
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function eventHandler(event:Event):void
		{
			const eventConstructor:Class = event["constructor"] as Class;
			var payloadEventClass:Class;
			//not pretty, but optimized to avoid duplicate checks and shortest paths
			if (eventConstructor == _eventClass || (!_eventClass))
			{
				payloadEventClass = eventConstructor;
			}
			else if (_eventClass == Event)
			{
				payloadEventClass = _eventClass;
			}
			else
			{
				return;
			}
			_executor.executeCommands(_mappings.getList(), new CommandPayload([event], [payloadEventClass]));
		}
	}
}

