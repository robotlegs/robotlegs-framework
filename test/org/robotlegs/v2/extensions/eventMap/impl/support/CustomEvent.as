//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.eventMap.impl.support
{
	import flash.events.Event;

	public class CustomEvent extends Event
	{
		public static const STARTED:String = 'started';
		public static const STOPPED:String = 'stopped';
		public static const EVENT0:String = 'event0';
		public static const EVENT1:String = 'event1';
		public static const EVENT2:String = 'event2';
		public static const EVENT3:String = 'event3';
		
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