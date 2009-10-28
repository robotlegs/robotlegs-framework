package org.robotlegs.mvcs.support
{
	import flash.events.Event;

	public class CustomEvent extends Event
	{
		public static const STARTED:String = 'started';
		public static const STOPPED:String = 'stopped';
		
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
