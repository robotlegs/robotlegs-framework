package net.boyblack.robotlegs.mvcs
{
	import flash.events.Event;

	public class ContextEvent extends Event
	{
		public static const STARTUP:String = 'startup';
		public static const STARTUP_COMPLETE:String = 'startupComplete';

		protected var _body:*;

		public function ContextEvent( type:String, body:* = null )
		{
			super( type );
			_body = body;
		}

		public function get body():*
		{
			return _body;
		}

		override public function clone():Event
		{
			return new ContextEvent( type, body );
		}

	}
}