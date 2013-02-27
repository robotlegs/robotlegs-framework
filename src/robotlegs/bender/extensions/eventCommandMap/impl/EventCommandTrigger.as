//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;

	/**
	 * @private
	 */
	public class EventCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:CommandMappingList = new CommandMappingList();

		private var _dispatcher:IEventDispatcher;

		private var _type:String;

		private var _executor:EventCommandExecutor;

		private var _eventClass:Class;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function EventCommandTrigger(
			injector:Injector,
			dispatcher:IEventDispatcher,
			type:String,
			eventClass:Class = null)
		{
			_dispatcher = dispatcher;
			_type = type;
			_eventClass = eventClass;
			_executor = new EventCommandExecutor(this, _mappings, injector, eventClass);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function addMapping(mapping:ICommandMapping):void
		{
			_mappings.head || addListener();
			_mappings.add(mapping);
		}

		/**
		 * @inheritDoc
		 */
		public function removeMapping(mapping:ICommandMapping):void
		{
			_mappings.remove(mapping);
			_mappings.head || removeListener();
		}

		public function toString():String
		{
			return _eventClass + " with selector '" + _type + "'";
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

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

