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
	import org.robotlegs.v2.extensions.commandMap.api.ICommandUnmapper;
	import org.swiftsuspenders.Injector;

	public class CommandMap implements ICommandMap
	{

		private const _mappings:Dictionary = new Dictionary();

		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		public function CommandMap(injector:Injector, dispatcher:IEventDispatcher):void
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
		}

		public function map(commandClass:Class):ICommandMapper
		{
			return _mappings[commandClass] ||= createMapping(commandClass);
		}

		public function unmap(commandClass:Class):ICommandUnmapper
		{
			return _mappings[commandClass];
		}

		public function unmapAll(commandClass:Class):void
		{
			const mapping:ICommandMapping = _mappings[commandClass];
			if (mapping)
			{
				delete _mappings[commandClass];
				mapping.unmap().fromAll();
			}
		}

		public function hasMapping(commandClass:Class):Boolean
		{
			return _mappings[commandClass];
		}

		private function createMapping(commandClass:Class):ICommandMapper
		{
			return new CommandMapping(_injector, _dispatcher, this, commandClass);
		}
	}
}
