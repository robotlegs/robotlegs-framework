//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.utils.Dictionary;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapper;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandUnmapper;
	import org.swiftsuspenders.Injector;

	public class CommandMapper implements ICommandMapper, ICommandUnmapper
	{
		private const mappings:Dictionary = new Dictionary();

		private var injector:Injector;

		private var trigger:ICommandTrigger;

		public function CommandMapper(injector:Injector, trigger:ICommandTrigger)
		{
			this.injector = injector;
			this.trigger = trigger;
		}

		public function toCommand(commandClass:Class):ICommandMapping
		{
			return mappings[commandClass] ||= createMapping(commandClass);
		}

		public function fromCommand(commandClass:Class):ICommandMapping
		{
			const mapping:ICommandMapping = mappings[commandClass];
			trigger.removeMapping(mapping);
			delete mappings[commandClass];
			return mapping;
		}

		public function forCommand(commandClass:Class):ICommandMapping
		{
			return mappings[commandClass];
		}

		private function createMapping(commandClass:Class):ICommandMapping
		{
			const mapping:ICommandMapping = new CommandMapping(injector, commandClass);
			trigger.addMapping(mapping);
			return mapping;
		}
	}
}
