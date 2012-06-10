// ------------------------------------------------------------------------------
// Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
// NOTICE: You are permitted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// ------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.impl {
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.framework.impl.guardsApprove;

	import org.swiftsuspenders.Injector;

	import flash.events.Event;

	public class EventCommandExecutor {
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		private var _injector : Injector;
		private var _eventClass : Class;
		private var _event : Event;
		private var _mappings : Vector.<ICommandMapping>;
		private var _appliedMappings : Vector.<ICommandMapping>;
		private var _commands : Vector.<*>;
		private var _eventConstructor : Class;
		private var _once : Boolean;

		/*============================================================================*/
		/* Constructor                                                         */
		/*============================================================================*/
		public function EventCommandExecutor(injector : Injector, eventClass : Class, once : Boolean) {
			_injector = injector.createChildInjector();
			_eventClass = eventClass;
			_once = once;
		}

		/*============================================================================*/
		/* Public Functions                                                         */
		/*============================================================================*/
		public function execute() : void {
			for each ( var command:* in _commands)
				command.execute();
			cleanup();
		}

		private function cleanup() : void {
			_event = null;
			_eventConstructor = null;
			_mappings = null;
			_appliedMappings = null;
			_commands = null;
		}

		public function prepare(event : Event, mappings : Vector.<ICommandMapping>) : Vector.<ICommandMapping> {
			_event = event;
			_eventConstructor = _event["constructor"] as Class;
			_mappings = mappings;

			prepareCommands();

			return _appliedMappings;
		}

		/*============================================================================*/
		/* Private Functions                                                         */
		/*============================================================================*/
		private function prepareCommands() : void {
			mapEventForInjection();
			findApplicableMappings();
			instantiateCommands();
			unmapEventAfterInjection();
		}

		private function mapEventForInjection() : void {
			mapLooselyTypedEvent();
			mapStronglyTypedEvent();
		}

		private function findApplicableMappings() : void {
			_appliedMappings = new <ICommandMapping>[];
			var i : int = -1;
			for each ( var mapping:ICommandMapping in _mappings) {
				if ( guardsApprove(mapping.guards, _injector) )
					_appliedMappings[++i] = mapping;
			}
		}

		private function mapLooselyTypedEvent() : void {
			_injector.map(Event).toValue(_event);
		}

		private function mapStronglyTypedEvent() : void {
			if (isStronglyTyped)
				_injector.map(eventType).toValue(_event);
		}

		private function instantiateCommands() : void {
			_commands = new <*>[];
			for each (var mapping:ICommandMapping in _appliedMappings)
				_commands.push(new EventCommandFactory(mapping, _injector).create());
		}

		private function unmapEventAfterInjection() : void {
			unmapLooselyTypedEvent();
			unmapStronglyTypedEvent();
		}

		private function unmapLooselyTypedEvent() : void {
			_injector.unmap(Event);
		}

		private function unmapStronglyTypedEvent() : void {
			if (isStronglyTyped)
				_injector.unmap(eventType);
		}

		private function get eventType() : Class {
			return _eventClass || _eventConstructor;
		}

		private function get isStronglyTyped() : Boolean {
			return _eventConstructor != Event;
		}
	}
}
