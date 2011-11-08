//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapper;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandUnmapper;
	import org.robotlegs.v2.extensions.guards.api.IGuardGroup;
	import org.robotlegs.v2.extensions.guards.impl.GuardGroup;
	import org.robotlegs.v2.extensions.hooks.api.IHookGroup;
	import org.robotlegs.v2.extensions.hooks.impl.HookGroup;
	import org.swiftsuspenders.Injector;

	public class CommandMapping implements ICommandMapping, ICommandMapper, ICommandUnmapper
	{

		private var _commandClass:Class;

		public function get commandClass():Class
		{
			return _commandClass;
		}

		private var _guards:IGuardGroup;

		public function get guards():IGuardGroup
		{
			return _guards;
		}

		private var _hooks:IHookGroup;

		public function get hooks():IHookGroup
		{
			return _hooks;
		}

		private const eventTriggers:Dictionary = new Dictionary();

		private const triggers:Vector.<ICommandTrigger> = new Vector.<ICommandTrigger>;

		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		private var _commandMap:ICommandMap;

		public function CommandMapping(
			injector:Injector,
			dispatcher:IEventDispatcher,
			commandMap:ICommandMap,
			commandClass:Class)
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
			_commandMap = commandMap;
			_commandClass = commandClass;
			_guards = new GuardGroup(_injector);
			_hooks = new HookGroup(_injector);
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
			if (triggers.length == 0)
				_commandMap.unmapAll(commandClass);
			return this;
		}

		public function fromAll():void
		{
			const triggersToRemove:Vector.<ICommandTrigger> = triggers.slice();
			for each (var trigger:ICommandTrigger in triggersToRemove)
			{
				fromTrigger(trigger);
			}
		}

		public function withGuards(... guardClasses):ICommandMapper
		{
			for each (var guardClass:* in guardClasses)
			{
				_guards.add(guardClass);
			}
			return this;
		}

		public function withHooks(... hookClasses):ICommandMapper
		{
			for each (var hookClass:* in hookClasses)
			{
				_hooks.add(hookClass);
			}
			return this;
		}
	}
}
