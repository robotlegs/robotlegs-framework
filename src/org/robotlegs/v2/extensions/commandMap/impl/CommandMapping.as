//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.guards.api.IGuardGroup;
	import org.robotlegs.v2.extensions.guards.impl.GuardGroup;
	import org.robotlegs.v2.extensions.hooks.api.IHookGroup;
	import org.robotlegs.v2.extensions.hooks.impl.HookGroup;
	import org.swiftsuspenders.Injector;

	public class CommandMapping implements ICommandMapping
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

		public function CommandMapping(injector:Injector, commandClass:Class)
		{
			_commandClass = commandClass;
			_guards = new GuardGroup(injector);
			_hooks = new HookGroup(injector);
		}

		public function withGuards(... guardClasses):ICommandMapping
		{
			_guards.add.apply(null, guardClasses)
			return this;
		}

		public function withHooks(... hookClasses):ICommandMapping
		{
			_hooks.add.apply(null, hookClasses)
			return this;
		}
	}
}
