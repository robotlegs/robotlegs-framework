//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMapping;
	import org.robotlegs.v2.extensions.guards.api.IGuardGroup;
	import org.robotlegs.v2.extensions.hooks.api.IHookGroup;
	import org.swiftsuspenders.Injector;
	import org.robotlegs.v2.extensions.guards.impl.GuardGroup;
	import org.robotlegs.v2.extensions.hooks.impl.HookGroup;

	public class MediatorConfig implements IMediatorConfig
	{
		public function MediatorConfig(mapping:IMediatorMapping, injector:Injector)
		{
			_mapping = mapping;
			_guards = new GuardGroup(injector);
			_hooks = new HookGroup(injector);
		}
		
		private var _mapping:IMediatorMapping;

		public function get mapping():IMediatorMapping
		{
			return _mapping;
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
		
		public function withGuards(... guardClasses):IMediatorConfig
		{
			_guards.add.apply(null, guardClasses);
			return this;
		}

		public function withHooks(... hookClasses):IMediatorConfig
		{
			_hooks.add.apply(null, hookClasses);
			return this;
		}
	}
}