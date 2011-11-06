//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.guardsAndHooks.api.IGuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.api.IHooksProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessor;
	import org.swiftsuspenders.Injector;

	public class EventCommandTrigger implements ICommandTrigger
	{
		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _eventClass:Class;

		private var _oneshot:Boolean;

		private var _mapping:ICommandMapping;

		private const guardsProcessor:IGuardsProcessor = new GuardsProcessor();

		private const hooksProcessor:IHooksProcessor = new HooksProcessor();

		public function EventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class,
			oneshot:Boolean)
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
			_type = type;
			_eventClass = eventClass;
			_oneshot = oneshot;
		}

		public function register(mapping:ICommandMapping):void
		{
			_mapping = mapping;
			verifyCommandClass();
			addListener();
		}

		public function unregister():void
		{
			removeListener();
		}

		private function verifyCommandClass():void
		{
			if (describeType(_mapping.commandClass).factory.method.(@name == "execute").length() == 0)
				throw new Error("Command Class must expose an execute method");
		}

		private function addListener():void
		{
			_dispatcher.addEventListener(_type, handleEvent);
		}

		private function removeListener():void
		{
			_dispatcher.removeEventListener(_type, handleEvent);
		}

		private function handleEvent(event:Event):void
		{
			// check strongly-typed event (if specified)
			if (_eventClass && _eventClass != Event && _eventClass != event["constructor"])
				return;

			// map the event for injection
			_injector.map(Event).toValue(event);

			// map the strongly typed event for injection
			if (_eventClass && _eventClass != Event)
				_injector.map(_eventClass).toValue(event);

			// execute the command if allowed
			if (allowedByGuards())
			{
				_injector.map(_mapping.commandClass).asSingleton();
				runHooks();
				executeCommand();
				_injector.unmap(_mapping.commandClass);
			}

			// unmap the event
			_injector.unmap(Event);

			// unmap the strongly-typed event
			if (_eventClass && _eventClass != Event)
				_injector.unmap(_eventClass);
		}

		private function allowedByGuards():Boolean
		{
			return _mapping.guards.length == 0
				|| guardsProcessor.processGuards(_injector, _mapping.guards);
		}

		private function runHooks():void
		{
			if (_mapping.hooks.length > 0)
				hooksProcessor.runHooks(_injector, _mapping.hooks);
		}

		private function executeCommand():void
		{
			_injector.getInstance(_mapping.commandClass).execute();

			// question - should this be fromAll()?
			_oneshot && _mapping.unmap().fromTrigger(this);
		}
	}
}
