//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{
	import flash.events.Event;

	/**
	 * Robotlegs object lifecycle event
	 */
	public class LifecycleEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const ERROR:String = "_error";

		public static const STATE_CHANGE:String = "stateChange";

		public static const PRE_INITIALIZE:String = "preInitialize";

		public static const INITIALIZE:String = "initialize";

		public static const POST_INITIALIZE:String = "postInitialize";

		public static const PRE_SUSPEND:String = "preSuspend";

		public static const SUSPEND:String = "suspend";

		public static const POST_SUSPEND:String = "postSuspend";

		public static const PRE_RESUME:String = "preResume";

		public static const RESUME:String = "resume";

		public static const POST_RESUME:String = "postResume";

		public static const PRE_DESTROY:String = "preDestroy";

		public static const DESTROY:String = "destroy";

		public static const POST_DESTROY:String = "postDestroy";

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _error:Error;

		/**
		 * Associated lifecycle error
		 */
		public function get error():Error
		{
			return _error;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Lifecycle Event
		 * @param type The event type
		 * @param error Optional error
		 */
		function LifecycleEvent(type:String, error:Error = null)
		{
			super(type);
			_error = error;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new LifecycleEvent(type, error);
		}
	}
}
