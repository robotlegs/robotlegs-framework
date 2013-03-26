//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.support
{
	import flash.events.Event;

	public class EventInjectedCallbackHook{
		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var event:Event;

		[Inject(name="hookCallback")]
		public var callback:Function;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function hook():void
		{
			callback(this);
		}
	}
}