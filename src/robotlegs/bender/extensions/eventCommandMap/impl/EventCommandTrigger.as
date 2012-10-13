//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;

	public class EventCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappingList:CommandMappingList = new CommandMappingList();

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _executor:EventCommandExecutor;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class = null)
		{
			_dispatcher = dispatcher;
			_type = type;
			_executor = new EventCommandExecutor(this, _mappingList, injector, eventClass);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addMapping(mapping:ICommandMapping):void
		{
			verifyCommandClass(mapping);
			if (_mappingList.tail)
			{
				_mappingList.tail.next = mapping;
			}
			else
			{
				_mappingList.head = mapping;
				addListener();
			}
		}

		public function removeMapping(mapping:ICommandMapping):void
		{
			_mappingList.remove(mapping);

			if (!_mappingList.head)
				removeListener();
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
			_dispatcher.addEventListener(_type, _executor.execute);
		}

		private function removeListener():void
		{
			_dispatcher.removeEventListener(_type, _executor.execute);
		}
	}
}
