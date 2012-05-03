//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
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

		public static const ERROR:String = "error";

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

		public var error:Error;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		function LifecycleEvent(type:String)
		{
			super(type);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function clone():Event
		{
			const event:LifecycleEvent = new LifecycleEvent(type);
			event.error = error;
			return event;
		}
	}
}
