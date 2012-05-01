//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
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
	import robotlegs.bender.framework.impl.guardsApprove;
	import robotlegs.bender.framework.impl.applyHooks;

	public class EventCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>;

		private var _injector:Injector;

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _eventClass:Class;

		private var _once:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class = null,
			once:Boolean = false)
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
			_type = type;
			_eventClass = eventClass;
			_once = once;
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
			const index:int = _mappings.indexOf(mapping);
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
			const eventConstructor:Class = event["constructor"];

			// check strongly-typed event (if specified)
			if (_eventClass && eventConstructor != _eventClass)
				return;

			// map loosely typed event for injection
			_injector.map(Event).toValue(event);

			// map the strongly typed event for injection
			if (eventConstructor != Event)
				_injector.map(_eventClass || eventConstructor).toValue(event);

			// run past the guards and hooks, and execute
			const mappings:Vector.<ICommandMapping> = _mappings.concat();
			for each (var mapping:ICommandMapping in mappings)
			{
				if (guardsApprove(mapping.guards, _injector))
				{
					_once && removeMapping(mapping);
					_injector.map(mapping.commandClass).asSingleton();
					const command:Object = _injector.getInstance(mapping.commandClass);
					applyHooks(mapping.hooks, _injector);
					_injector.unmap(mapping.commandClass);
					command.execute();
				}
			}

			// unmap the loosely typed event
			_injector.unmap(Event);

			// unmap the strongly typed event
			if (eventConstructor != Event)
				_injector.unmap(_eventClass || eventConstructor);
		}
	}
}
