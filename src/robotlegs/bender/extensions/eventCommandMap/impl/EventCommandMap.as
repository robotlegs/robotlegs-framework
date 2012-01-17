//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandMap.api.ICommandMap;
	import robotlegs.bender.extensions.commandMap.api.ICommandMapper;
	import robotlegs.bender.extensions.commandMap.api.ICommandMappingFinder;
	import robotlegs.bender.extensions.commandMap.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandMap.api.ICommandUnmapper;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

	public class EventCommandMap implements IEventCommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _eventTriggers:Dictionary = new Dictionary();

		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		private var _commandMap:ICommandMap;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandMap(injector:Injector, dispatcher:IEventDispatcher, commandMap:ICommandMap)
		{
			_injector = injector;
			_dispatcher = dispatcher;
			_commandMap = commandMap;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(type:String, eventClass:Class = null, once:Boolean = false):ICommandMapper
		{
			const trigger:ICommandTrigger =
				_eventTriggers[type + eventClass] ||=
				createEventTrigger(type, eventClass, once);
			return _commandMap.map(trigger);
		}

		public function unmap(type:String, eventClass:Class = null):ICommandUnmapper
		{
			return _commandMap.unmap(getEventTrigger(type, eventClass));
		}

		public function getMapping(type:String, eventClass:Class = null):ICommandMappingFinder
		{
			const trigger:ICommandTrigger = getEventTrigger(type, eventClass);
			return _commandMap.getMapping(trigger);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createEventTrigger(type:String, eventClass:Class = null, once:Boolean = false):ICommandTrigger
		{
			return new EventCommandTrigger(_injector, _dispatcher, type, eventClass, once);
		}

		private function getEventTrigger(type:String, eventClass:Class = null):ICommandTrigger
		{
			return _eventTriggers[type + eventClass];
		}
	}
}
