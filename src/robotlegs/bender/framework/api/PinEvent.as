//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{
	import flash.events.Event;

	public class PinEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const DETAIN:String = "detain";

		public static const RELEASE:String = "release";

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _instance:Object;

		public function get instance():Object
		{
			return _instance;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function PinEvent(type:String, instance:Object)
		{
			super(type);
			_instance = instance;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function clone():Event
		{
			return new PinEvent(type, _instance);
		}
	}
}
