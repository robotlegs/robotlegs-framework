//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.extensions.commandMap.api.ICommandTrigger;

	public class EventCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>;

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _eventClass:Class;

		private var _executor:EventCommandExecutor;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandTrigger(injector:Injector, dispatcher:IEventDispatcher, type:String, eventClass:Class = null)
		{
			_dispatcher = dispatcher;
			_type = type;
			_eventClass = eventClass;
			_executor = new EventCommandExecutor(injector, eventClass);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addMapping(mapping:ICommandMapping):void
		{
			verifyCommandClass(mapping);
			_mappings.push(mapping);
			if (_mappings.length == 1)
				addListener();
		}

		public function removeMapping(mapping:ICommandMapping):void
		{
			var index:int = _mappings.indexOf(mapping);
			if (index != -1)
			{
				_mappings.splice(index, 1);
				if (_mappings.length == 0)
					removeListener();
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function verifyCommandClass(mapping:ICommandMapping):void
		{
			if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
				throw new Error("Command Class must expose an execute method");
		}

		private function addListener():void
		{
			_dispatcher.addEventListener(_type, handleEvent);
		}

		private function removeListener():void
		{
			_dispatcher.removeEventListener(_type, handleEvent);
		}

		private function handleEvent(event:Event):void
		{
			if (isTriggerEvent(event))
			{
				const appliedMappings:Vector.<ICommandMapping> = _executor.prepare(event, _mappings.concat());
				removeFireOnceMappings(appliedMappings);
				_executor.execute();
			}
		}

		private function isTriggerEvent(event:Event):Boolean
		{
			return !_eventClass || event["constructor"] == _eventClass;
		}

		private function removeFireOnceMappings(mappings:Vector.<ICommandMapping>):void
		{
			for each (var mapping:ICommandMapping in mappings)
			{
				if (mapping.fireOnce)
					removeMapping(mapping);
			}
		}
	}
}
