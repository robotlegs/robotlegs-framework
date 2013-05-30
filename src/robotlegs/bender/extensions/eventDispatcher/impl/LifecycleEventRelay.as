//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventDispatcher.impl
{
	import flash.events.IEventDispatcher;
	import robotlegs.bender.framework.api.LifecycleEvent;

	/**
	 * @private
	 */
	public class LifecycleEventRelay
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const TYPES:Array = [
			LifecycleEvent.STATE_CHANGE,
			LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE,
			LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND,
			LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME,
			LifecycleEvent.PRE_DESTROY, LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY];

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _relay:EventRelay;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function LifecycleEventRelay(source:IEventDispatcher, destination:IEventDispatcher)
		{
			_relay = new EventRelay(source, destination, TYPES).start();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function destroy():void
		{
			_relay.stop();
			_relay = null;
		}
	}
}
