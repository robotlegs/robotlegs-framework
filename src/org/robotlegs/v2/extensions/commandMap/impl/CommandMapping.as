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
	import flash.utils.Dictionary;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapper;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandUnmapper;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsAndHooksConfig;
	import org.swiftsuspenders.Injector;

	public class CommandMapping extends GuardsAndHooksConfig implements ICommandMapping, ICommandMapper, ICommandUnmapper
	{

		private var _commandClass:Class;

		public function get commandClass():Class
		{
			return _commandClass;
		}

		private const eventTriggers:Dictionary = new Dictionary();

		private const triggers:Vector.<ICommandTrigger> = new Vector.<ICommandTrigger>;

		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		public function CommandMapping(injector:Injector, dispatcher:IEventDispatcher, commandClass:Class)
		{
			_injector = injector;
			_dispatcher = dispatcher;
			_commandClass = commandClass;
		}

		public function toEvent(type:String, eventClass:Class = null, oneshot:Boolean = false):ICommandMapper
		{
			const trigger:ICommandTrigger = new EventCommandTrigger(_injector, _dispatcher, type, eventClass, oneshot);
			eventTriggers[type + eventClass] = trigger;
			toTrigger(trigger);
			return this;
		}

		public function toTrigger(trigger:ICommandTrigger):ICommandMapper
		{
			triggers.push(trigger);
			trigger.register(this);
			return this;
		}

		public function unmap():ICommandUnmapper
		{
			return this;
		}

		public function fromEvent(type:String, eventClass:Class = null):ICommandUnmapper
		{
			const trigger:ICommandTrigger = eventTriggers[type + eventClass];
			fromTrigger(trigger);
			return this;
		}

		public function fromTrigger(trigger:ICommandTrigger):ICommandUnmapper
		{
			const index:int = triggers.indexOf(trigger);
			trigger.unregister();
			triggers.splice(index, 1);
			// todo: destroy
			return this;
		}

		public function fromAll():void
		{
			for each (var trigger:ICommandTrigger in triggers)
			{
				trigger.unregister();
			}
			triggers.length = 0;
		}

		public function numTriggers():uint
		{
			return triggers.length;
		}
	}
}
