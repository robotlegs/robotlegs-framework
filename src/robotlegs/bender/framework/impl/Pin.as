//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import robotlegs.bender.framework.api.PinEvent;

	/**
	 * Pins objects in memory
	 *
	 * @private
	 */
	public class Pin
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _instances:Dictionary = new Dictionary(false);

		private var _dispatcher:IEventDispatcher;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function Pin(dispatcher:IEventDispatcher)
		{
			_dispatcher = dispatcher;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * Pin an object in memory
		 * @param instance Instance to pin
		 */
		public function detain(instance:Object):void
		{
			if (!_instances[instance])
			{
				_instances[instance] = true;
				_dispatcher.dispatchEvent(new PinEvent(PinEvent.DETAIN, instance));
			}
		}

		/**
		 * Unpins an object
		 * @param instance Instance to unpin
		 */
		public function release(instance:Object):void
		{
			if (_instances[instance])
			{
				delete _instances[instance];
				_dispatcher.dispatchEvent(new PinEvent(PinEvent.RELEASE, instance));
			}
		}

		/**
		 * Removes all pins
		 */
		public function releaseAll():void
		{
			for (var instance:Object in _instances)
			{
				release(instance);
			}
		}
	}
}
