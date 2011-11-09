//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.swiftsuspenders.Injector;

	public class EventCommandTrigger implements ICommandTrigger
	{
		private const mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>;

		private var injector:Injector;

		private var dispatcher:IEventDispatcher;

		private var type:String;

		private var eventClass:Class;

		private var once:Boolean;

		public function EventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class,
			once:Boolean = false)
		{
			this.injector = injector;
			this.dispatcher = dispatcher;
			this.type = type;
			this.eventClass = eventClass;
			this.once = once;
		}

		public function addMapping(mapping:ICommandMapping):void
		{
			verifyCommandClass(mapping);
			mappings.push(mapping);
			if (mappings.length == 1)
				addListener();
		}

		public function removeMapping(mapping:ICommandMapping):void
		{
			const index:int = mappings.indexOf(mapping);
			if (index != -1)
			{
				mappings.splice(index, 1);
				if (mappings.length == 0)
					removeListener();
			}
		}

		private function verifyCommandClass(mapping:ICommandMapping):void
		{
			if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
				throw new Error("Command Class must expose an execute method");
		}

		private function addListener():void
		{
			dispatcher.addEventListener(type, handleEvent);
		}

		private function removeListener():void
		{
			dispatcher.removeEventListener(type, handleEvent);
		}

		private function handleEvent(event:Event):void
		{
			// check strongly-typed event (if specified)
			if (eventClass && eventClass != Event && eventClass != event["constructor"])
				return;

			// map the event for injection
			injector.map(Event).toValue(event);

			// map the strongly typed event for injection
			if (eventClass && eventClass != Event)
				injector.map(eventClass).toValue(event);

			for each (var mapping:ICommandMapping in mappings)
			{
				// execute the command if allowed
				if (mapping.guards.approve())
				{
					injector.map(mapping.commandClass).asSingleton();
					mapping.hooks.hook();
					injector.getInstance(mapping.commandClass).execute();
					injector.unmap(mapping.commandClass);
					// question - should this be fromAll()?
					once && removeMapping(mapping);
				}
			}

			// unmap the event
			injector.unmap(Event);

			// unmap the strongly-typed event
			if (eventClass && eventClass != Event)
				injector.unmap(eventClass);
		}
	}
}
