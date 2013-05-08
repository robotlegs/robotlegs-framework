//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.utils
{
	import flash.events.IEventDispatcher;

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
		public function EventRelay(source:IEventDispatcher, destination:IEventDispatcher, types:Array)
		{
			_source = source;
			_destination = destination;
			_types = types;
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

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addListeners():void
		{
			for each (var type:String in _types)
			{
				_source.addEventListener(type, _destination.dispatchEvent);
			}
		}

		private function removeListeners():void
		{
			for each (var type:String in _types)
			{
				_source.removeEventListener(type, _destination.dispatchEvent);
			}
		}
	}
}
