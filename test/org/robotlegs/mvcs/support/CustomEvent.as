package org.robotlegs.mvcs.support
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
