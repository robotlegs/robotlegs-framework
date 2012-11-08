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
	import robotlegs.bender.framework.impl.applyHooks;
	import robotlegs.bender.framework.impl.guardsApprove;

	public class EventCommandExecutor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _trigger:ICommandTrigger;

		private var _mappingList:CommandMappingList;

		private var _injector:Injector;

		private var _eventClass:Class;

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
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function execute(event:Event):void
		{
			const eventConstructor:Class = event["constructor"] as Class;
			if (_eventClass && eventConstructor != _eventClass)
			{
				return;
			}

			for (var mapping:ICommandMapping = _mappingList.head; mapping; mapping = mapping.next)
			{
				var command:Object;

				// ss: I don't like that we have to do this work at execution time
				mapping.validate();

				_injector.map(Event).toValue(event);
				if (eventConstructor != Event)
					_injector.map(_eventClass || eventConstructor).toValue(event);

				if (guardsApprove(mapping.guards, _injector))
				{
					const commandClass:Class = mapping.commandClass;
					_injector.map(commandClass).asSingleton();
					command = _injector.getInstance(commandClass);
					applyHooks(mapping.hooks, _injector);
					_injector.unmap(commandClass);
				}

				_injector.unmap(Event);
				if (eventConstructor != Event)
					_injector.unmap(_eventClass || eventConstructor);

				if (command)
				{
					mapping.fireOnce && _trigger.removeMapping(mapping);
					command.execute();
				}
			}
		}
	}
}
