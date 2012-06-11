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
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.extensions.commandMap.api.ICommandTrigger;
	import robotlegs.bender.framework.impl.guardsApprove;

	public class EventCommandExecutor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _trigger:ICommandTrigger;

		private var _mappings:Vector.<ICommandMapping>;

		private var _injector:Injector;

		private var _eventClass:Class;

		private var _factory:EventCommandFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandExecutor(
			trigger:ICommandTrigger,
			mappings:Vector.<ICommandMapping>,
			injector:Injector,
			eventClass:Class)
		{
			_trigger = trigger;
			_mappings = mappings;
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
				mapEventForInjection(event, eventConstructor);
				const approvedMappings:Vector.<ICommandMapping> = findApprovedMappings(_mappings);
				const commands:Array = createCommands(approvedMappings);
				unmapEventAfterInjection(eventConstructor);
				removeFireOnceMappings(approvedMappings);

				for each (var command:Object in commands)
					command.execute();
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

		private function findApprovedMappings(mappings:Vector.<ICommandMapping>):Vector.<ICommandMapping>
		{
			const approvedMappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();
			var i:int = -1;
			for each (var mapping:ICommandMapping in mappings)
			{
				if (guardsApprove(mapping.guards, _injector))
					approvedMappings[++i] = mapping;
			}
			return approvedMappings;
		}

		private function createCommands(mappings:Vector.<ICommandMapping>):Array
		{
			const commands:Array = [];
			for each (var mapping:ICommandMapping in mappings)
			{
				commands.push(_factory.create(mapping));
			}
			return commands;
		}

		private function removeFireOnceMappings(mappings:Vector.<ICommandMapping>):void
		{
			for each (var mapping:ICommandMapping in mappings)
			{
				if (mapping.fireOnce)
					_trigger.removeMapping(mapping);
			}
		}
	}
}
