//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.lifecycle
{
	import flash.events.Event;

	public class LifecycleEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const PRE_INITIALIZE:String = "preInitialize";

		public static const INITIALIZE:String = "initialize";

		public static const POST_INITIALIZE:String = "postInitialize";

		public static const ERROR:String = "error";

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
