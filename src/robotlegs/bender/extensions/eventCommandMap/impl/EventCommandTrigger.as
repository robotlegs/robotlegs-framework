//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.impl.CommandExecutor;

	/**
	 * @private
	 */
	public class EventCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _executor:ICommandExecutor;

		public function get executor():ICommandExecutor
		{
			return _executor;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _eventClass:Class;

		private var _injector:Injector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function EventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class = null)
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
			_type = type;
			_eventClass = eventClass;
			_executor = new CommandExecutor(_injector)
				.withPayloadMapper(mapPayload)
				.withPayloadUnmapper(unmapPayload);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function activate():void
		{
			_dispatcher.addEventListener(_type, eventHandler);
		}

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
			if (_eventClass && eventConstructor != _eventClass)
			{
				return;
			}
			_executor.execute(event, eventConstructor);
		}

		private function mapPayload(event:Event, eventClass:Class):void
		{
			_injector.map(Event).toValue(event);
			if (eventClass != Event)
				_injector.map(_eventClass || eventClass).toValue(event);
		}

		private function unmapPayload(event:Event, eventClass:Class):void
		{
			_injector.unmap(Event);
			if (eventClass != Event)
				_injector.unmap(_eventClass || eventClass);
		}
	}
}

