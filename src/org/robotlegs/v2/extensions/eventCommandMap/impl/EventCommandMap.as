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
	import flash.utils.Dictionary;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapper;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMappingFinder;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandUnmapper;
	import org.robotlegs.v2.extensions.eventCommandMap.api.IEventCommandMap;
	import org.swiftsuspenders.Injector;

	public class EventCommandMap implements IEventCommandMap
	{
		private const eventTriggers:Dictionary = new Dictionary();

		private var injector:Injector;

		private var dispatcher:IEventDispatcher;

		private var commandMap:ICommandMap;

		public function EventCommandMap(injector:Injector, dispatcher:IEventDispatcher, commandMap:ICommandMap)
		{
			this.injector = injector;
			this.dispatcher = dispatcher;
			this.commandMap = commandMap;
		}

		public function map(type:String, eventClass:Class = null, once:Boolean = false):ICommandMapper
		{
			const trigger:ICommandTrigger =
				eventTriggers[type + (eventClass || Event)] ||=
				createEventTrigger(type, eventClass, once);
			return commandMap.map(trigger);
		}

		public function unmap(type:String, eventClass:Class = null):ICommandUnmapper
		{
			return commandMap.unmap(getEventTrigger(type, eventClass));
		}

		public function getMapping(type:String, eventClass:Class = null):ICommandMappingFinder
		{
			const trigger:ICommandTrigger = getEventTrigger(type, eventClass);
			return commandMap.getMapping(trigger);
		}

		private function createEventTrigger(type:String, eventClass:Class = null, once:Boolean = false):ICommandTrigger
		{
			return new EventCommandTrigger(injector, dispatcher, type, (eventClass || Event), once);
		}

		private function getEventTrigger(type:String, eventClass:Class = null):ICommandTrigger
		{
			return eventTriggers[type + (eventClass || Event)];
		}
	}
}
