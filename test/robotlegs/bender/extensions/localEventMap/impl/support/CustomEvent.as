//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap.impl.support
{
	import flash.events.Event;

	public class CustomEvent extends Event
	{
		public static const STARTED:String = 'started';

		public function CustomEvent(type:String)
		{
			super(type);
		}

		override public function clone():Event
		{
			return new CustomEvent(type);
		}
	}
}