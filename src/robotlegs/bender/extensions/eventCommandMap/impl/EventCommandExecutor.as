//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;

	public class EventCommandExecutor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _trigger:ICommandTrigger;

		private var _mappingList:CommandMappingList;

		private var _injector:Injector;

		private var _eventClass:Class;

		private var _factory:EventCommandFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandExecutor(
			trigger:ICommandTrigger,
			mappingList:CommandMappingList,
			injector:Injector,
			eventClass:Class)
		{
			_trigger = trigger;
			_mappingList = mappingList;
			_injector = injector.createChildInjector();
			_eventClass = eventClass;
			_factory = new EventCommandFactory(_injector);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function execute(event:Event):void
		{
			const eventConstructor:Class = event["constructor"] as Class;
			if (isTriggerEvent(eventConstructor))
			{
				runCommands(event, eventConstructor);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function isTriggerEvent(eventConstructor:Class):Boolean
		{
			return !_eventClass || eventConstructor == _eventClass;
		}

		private function isStronglyTyped(eventConstructor:Class):Boolean
		{
			return eventConstructor != Event;
		}

		private function mapEventForInjection(event:Event, eventConstructor:Class):void
		{
			_injector.map(Event).toValue(event);
			if (isStronglyTyped(eventConstructor))
				_injector.map(_eventClass || eventConstructor).toValue(event);
		}

		private function unmapEventAfterInjection(eventConstructor:Class):void
		{
			_injector.unmap(Event);
			if (isStronglyTyped(eventConstructor))
				_injector.unmap(_eventClass || eventConstructor);
		}

		private function runCommands(event:Event, eventConstructor:Class):void
		{
			var command:Object;
			
			for(var mapping:ICommandMapping = _mappingList.head; mapping; mapping = mapping.next)
			{
				mapping.validate();
				mapEventForInjection(event, eventConstructor);
				command = _factory.create(mapping);
				unmapEventAfterInjection(eventConstructor);
				if(command)
				{
					removeFireOnceMapping(mapping);
					command.execute();
				}
			}
		}

		private function removeFireOnceMapping(mapping:ICommandMapping):void
		{
			if (mapping.fireOnce)
				_trigger.removeMapping(mapping);
		}
	}
}