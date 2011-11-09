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
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapper;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandUnmapper;
	import org.swiftsuspenders.Injector;

	public class CommandMap implements ICommandMap
	{

		private const mappers:Dictionary = new Dictionary();

		private const eventTriggers:Dictionary = new Dictionary();

		private var injector:Injector;

		private var dispatcher:IEventDispatcher;

		public function CommandMap(injector:Injector, dispatcher:IEventDispatcher):void
		{
			this.injector = injector.createChildInjector();
			this.dispatcher = dispatcher;
		}

		public function mapTrigger(trigger:ICommandTrigger):ICommandMapper
		{
			return mappers[trigger] ||= createMapper(trigger);
		}

		public function mapEvent(type:String, eventClass:Class = null, once:Boolean = false):ICommandMapper
		{
			eventClass ||= Event;
			const trigger:ICommandTrigger =
				eventTriggers[type + eventClass] ||=
				new EventCommandTrigger(injector, dispatcher, type, eventClass, once);
			return mapTrigger(trigger);
		}

		public function unmapTrigger(trigger:ICommandTrigger):ICommandUnmapper
		{
			return mappers[trigger];
		}

		public function unmapEvent(type:String, eventClass:Class = null):ICommandUnmapper
		{
			return unmapTrigger(getEventTrigger(type, eventClass));
		}

		public function getTriggerMapping(trigger:ICommandTrigger, commandClass:Class):ICommandMapping
		{
			const mapper:CommandMapper = mappers[trigger];
			return mapper ? mapper.forCommand(commandClass) : null;
		}

		public function getEventMapping(type:String, eventClass:Class, commandClass:Class):ICommandMapping
		{
			const trigger:ICommandTrigger = getEventTrigger(type, eventClass);
			const mapper:CommandMapper = mappers[trigger];
			return mapper ? mapper.forCommand(commandClass) : null;
		}

		private function createMapper(trigger:ICommandTrigger):ICommandMapper
		{
			return new CommandMapper(injector, trigger);
		}

		private function getEventTrigger(type:String, eventClass:Class = null):ICommandTrigger
		{
			eventClass ||= Event;
			return eventTriggers[type + eventClass];
		}
	}
}
