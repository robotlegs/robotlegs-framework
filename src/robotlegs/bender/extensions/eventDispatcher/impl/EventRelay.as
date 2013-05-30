//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventDispatcher.impl
{
	import flash.events.IEventDispatcher;

	/**
	 * Relays events from a source to a destination
	 */
	public class EventRelay
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _source:IEventDispatcher;

		private var _destination:IEventDispatcher;

		private var _types:Array;

		private var _active:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Relays events from the source to the destination
		 * @param source Event Dispatcher
		 * @param destination Event Dispatcher
		 * @param types The list of event types to relay
		 */
		public function EventRelay(source:IEventDispatcher, destination:IEventDispatcher, types:Array = null)
		{
			_source = source;
			_destination = destination;
			_types = types || [];
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * Start relaying events
		 * @return Self
		 */
		public function start():EventRelay
		{
			if (!_active)
			{
				_active = true;
				addListeners();
			}
			return this;
		}

		/**
		 * Stop relaying events
		 * @return Self
		 */
		public function stop():EventRelay
		{
			if (_active)
			{
				_active = false;
				removeListeners();
			}
			return this;
		}

		/**
		 * Add a new event type to relay
		 * @param eventType
		 */
		public function addType(eventType:String):void
		{
			_types.push(eventType);
			_active && addListener(eventType);
		}

		/**
		 * Remove a relay event type
		 * @param eventType
		 */
		public function removeType(eventType:String):void
		{
			const index:int = _types.indexOf(eventType);
			if (index > -1)
			{
				_types.splice(index, 1);
				removeListener(eventType);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function removeListener(type:String):void
		{
			_source.removeEventListener(type, _destination.dispatchEvent);
		}

		private function addListener(type:String):void
		{
			_source.addEventListener(type, _destination.dispatchEvent);
		}

		private function addListeners():void
		{
			for each (var type:String in _types)
			{
				addListener(type);
			}
		}

		private function removeListeners():void
		{
			for each (var type:String in _types)
			{
				removeListener(type);
			}
		}
	}
}
