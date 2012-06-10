// ------------------------------------------------------------------------------
// Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
// NOTICE: You are permitted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// ------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.impl {
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.extensions.commandMap.api.ICommandTrigger;
	import robotlegs.bender.framework.impl.guardsApprove;

	import org.swiftsuspenders.Injector;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;

	public class EventCommandTrigger implements ICommandTrigger {
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		private const _mappings : Vector.<ICommandMapping> = new Vector.<ICommandMapping>;
		private var _dispatcher : IEventDispatcher;
		private var _injector : Injector;
		private var _type : String;
		private var _eventClass : Class;
		private var _executor : EventCommandExecutor;
		private var _once : Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		public function EventCommandTrigger(injector : Injector, dispatcher : IEventDispatcher, type : String, eventClass : Class = null, once : Boolean = false) {
			_injector = injector;
			_dispatcher = dispatcher;
			_type = type;
			_eventClass = eventClass;
			_executor = new EventCommandExecutor(injector, eventClass);
			_once = once;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		public function addMapping(mapping : ICommandMapping) : void {
			verifyCommandClass(mapping);
			_mappings.push(mapping);
			if (_mappings.length == 1)
				addListener();
		}

		public function removeMapping(mapping : ICommandMapping) : void {
			const index : int = _mappings.indexOf(mapping);
			if (index != -1) {
				_mappings.splice(index, 1);
				if (_mappings.length == 0)
					removeListener();
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/
		private function verifyCommandClass(mapping : ICommandMapping) : void {
			if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
				throw new Error("Command Class must expose an execute method");
		}

		private function addListener() : void {
			_dispatcher.addEventListener(_type, handleEvent);
		}

		private function removeListener() : void {
			_dispatcher.removeEventListener(_type, handleEvent);
		}

		private function handleEvent(event : Event) : void {
			if (isTriggerEvent(event)) {
				const applicableMappings : Vector.<ICommandMapping> = findApplicableMappings();
				_executor.execute(event, applicableMappings);
				if (_once)
					removeMappings(applicableMappings);
			}
		}

		private function isTriggerEvent(event : Event) : Boolean {
			return !_eventClass || event["constructor"] == _eventClass;
		}

		private function findApplicableMappings() : Vector.<ICommandMapping> {
			const applicableMappings : Vector.<ICommandMapping> = new <ICommandMapping>[];
			var i : int = -1;
			for each (var mapping:ICommandMapping in _mappings)
				if ( guardsApprove(mapping.guards, _injector) )
					applicableMappings[++i] = mapping;

			return applicableMappings;
		}

		private function removeMappings(mappings : Vector.<ICommandMapping>) : void {
			for each (var mapping:ICommandMapping in mappings)
				removeMapping(mapping);
		}
	}
}