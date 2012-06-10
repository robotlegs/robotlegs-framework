// ------------------------------------------------------------------------------
// Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
// NOTICE: You are permitted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// ------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.impl {
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;

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
		private var _eventConstructor : Class;

		/*============================================================================*/
		/* Constructor                                                         */
		/*============================================================================*/
		public function EventCommandExecutor(injector : Injector, eventClass : Class) {
			_injector = injector.createChildInjector();
			_eventClass = eventClass;
		}

		/*============================================================================*/
		/* Public Functions                                                         */
		/*============================================================================*/
		public function execute(event : Event, mappings : Vector.<ICommandMapping>) : void {
			_event = event;
			_eventConstructor = _event["constructor"] as Class;
			_mappings = mappings;

			executeCommands();

			_eventConstructor = null;
			_mappings = null;
			_event = null;
		}

		/*============================================================================*/
		/* Private Functions                                                         */
		/*============================================================================*/
		private function executeCommands() : void {
			mapEventForInjection();
			applyCommandMappings();
			unmapEventAfterInjection();
		}

		private function mapEventForInjection() : void {
			mapLooselyTypedEvent();
			mapStronglyTypedEvent();
		}

		private function mapLooselyTypedEvent() : void {
			_injector.map(Event).toValue(_event);
		}

		private function mapStronglyTypedEvent() : void {
			if (isStronglyTyped)
				_injector.map(eventType).toValue(_event);
		}

		private function applyCommandMappings() : void {
			const commands : Vector.<*> = instantiateCommands();
			for each ( var command:* in commands)
				command.execute();
		}

		private function instantiateCommands() : Vector.<*> {
			const commands : Vector.<*> = new <*>[];

			const mappings : Vector.<ICommandMapping> = _mappings.concat();
			for each (var mapping:ICommandMapping in mappings)
				commands.push(new EventCommandFactory(mapping, _injector).create());

			return commands;
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
