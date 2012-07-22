//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

	public class EventCommandMap implements IEventCommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _triggers:Dictionary = new Dictionary();

		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		private var _commandCenter:ICommandCenter;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandMap(
			injector:Injector,
			dispatcher:IEventDispatcher,
			commandCenter:ICommandCenter)
		{
			_injector = injector;
			_dispatcher = dispatcher;
			_commandCenter = commandCenter;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(type:String, eventClass:Class = null):ICommandMapper
		{
			const trigger:ICommandTrigger =
				_triggers[type + eventClass] ||=
				createTrigger(type, eventClass);
			return _commandCenter.map(trigger);
		}

		public function unmap(type:String, eventClass:Class = null):ICommandUnmapper
		{
			return _commandCenter.unmap(getTrigger(type, eventClass));
		}


		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createTrigger(type:String, eventClass:Class = null):ICommandTrigger
		{
			return new EventCommandTrigger(_injector, _dispatcher, type, eventClass);
		}

		private function getTrigger(type:String, eventClass:Class = null):ICommandTrigger
		{
			return _triggers[type + eventClass];
		}
	}
}
