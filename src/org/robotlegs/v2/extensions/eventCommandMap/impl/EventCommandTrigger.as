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

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _injector:Injector;

		public function get injector():Injector
		{
			return _injector;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>;

		private var dispatcher:IEventDispatcher;

		private var type:String;

		private var eventClass:Class;

		private var once:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class = null,
			once:Boolean = false)
		{
			this._injector = injector.createChildInjector();
			this.dispatcher = dispatcher;
			this.type = type;
			this.eventClass = eventClass;
			this.once = once;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

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

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

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
			const eventConstructor:Class = event["constructor"];

			// check strongly-typed event (if specified)
			if (eventClass && eventConstructor != eventClass)
				return;

			// map loosely typed event for injection
			_injector.map(Event).toValue(event);

			// map the strongly typed event for injection
			if (eventConstructor != Event)
				_injector.map(eventClass || eventConstructor).toValue(event);

			// run past the guards and hooks, and execute
			const mappings:Vector.<ICommandMapping> = this.mappings.concat();
			for each (var mapping:ICommandMapping in mappings)
			{
				if (mapping.guards.approve())
				{
					once && removeMapping(mapping);
					_injector.map(mapping.commandClass).asSingleton();
					const command:Object = _injector.getInstance(mapping.commandClass);
					mapping.hooks.hook();
					_injector.unmap(mapping.commandClass);
					command.execute();
				}
			}

			// unmap the loosely typed event
			_injector.unmap(Event);

			// unmap the strongly typed event
			if (eventConstructor != Event)
				_injector.unmap(eventClass || eventConstructor);
		}
	}
}
