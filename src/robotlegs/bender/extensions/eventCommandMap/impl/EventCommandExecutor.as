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
	import robotlegs.bender.framework.impl.guardsApprove;

	public class EventCommandExecutor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _eventClass:Class;

		private var _event:Event;

		private var _mappings:Vector.<ICommandMapping>;

		private var _appliedMappings:Vector.<ICommandMapping>;

		private var _commands:Vector.<Object>;

		private var _eventConstructor:Class;

		private function get isStronglyTyped():Boolean
		{
			return _eventConstructor != Event;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandExecutor(injector:Injector, eventClass:Class)
		{
			_injector = injector.createChildInjector();
			_eventClass = eventClass;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function prepare(event:Event, mappings:Vector.<ICommandMapping>):Vector.<ICommandMapping>
		{
			_event = event;
			_eventConstructor = _event["constructor"] as Class;
			_mappings = mappings;

			prepareCommands();

			return _appliedMappings;
		}

		public function execute():void
		{
			for each (var command:* in _commands)
				command.execute();
			cleanup();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function prepareCommands():void
		{
			mapEventForInjection();
			findApplicableMappings();
			instantiateCommands();
			unmapEventAfterInjection();
		}

		private function mapEventForInjection():void
		{
			mapLooselyTypedEvent();
			mapStronglyTypedEvent();
		}

		private function findApplicableMappings():void
		{
			_appliedMappings = new Vector.<ICommandMapping>();
			var i:int = -1;
			for each (var mapping:ICommandMapping in _mappings)
			{
				if (guardsApprove(mapping.guards, _injector))
					_appliedMappings[++i] = mapping;
			}
		}

		private function mapLooselyTypedEvent():void
		{
			_injector.map(Event).toValue(_event);
		}

		private function mapStronglyTypedEvent():void
		{
			if (isStronglyTyped)
				_injector.map(_eventClass || _eventConstructor).toValue(_event);
		}

		private function instantiateCommands():void
		{
			_commands = new Vector.<Object>();
			for each (var mapping:ICommandMapping in _appliedMappings)
			{
				var factory:EventCommandFactory = new EventCommandFactory(mapping, _injector);
				_commands.push(factory.create());
			}
		}

		private function unmapEventAfterInjection():void
		{
			unmapLooselyTypedEvent();
			unmapStronglyTypedEvent();
		}

		private function unmapLooselyTypedEvent():void
		{
			_injector.unmap(Event);
		}

		private function unmapStronglyTypedEvent():void
		{
			if (isStronglyTyped)
				_injector.unmap(_eventClass || _eventConstructor);
		}

		private function cleanup():void
		{
			_event = null;
			_eventConstructor = null;
			_mappings = null;
			_appliedMappings = null;
			_commands = null;
		}
	}
}
