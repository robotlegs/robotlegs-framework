package net.boyblack.robotlegs.utils
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class DelayedFunctionQueue
	{
		private static var instance:DelayedFunctionQueue;
		protected var queue:Array;
		protected var dispatcher:Sprite;

		public function DelayedFunctionQueue()
		{
			queue = new Array();
			dispatcher = new Sprite();
		}

		public function add( func:Function, ... args ):void
		{
			var delegateFn:Function = function():void
			{
				func.apply( null, args );
			}
			queue.push( delegateFn );
			if ( queue.length == 1 )
			{
				dispatcher.addEventListener( Event.ENTER_FRAME, onEF, false, 0, true );
			}
		}

		public static function add( func:Function, ... args ):void
		{
			instance = instance ? instance : new DelayedFunctionQueue();
			instance.add.apply( null, [ func ].concat( args ) );
		}

		protected function onEF( event:Event ):void
		{
			dispatcher.removeEventListener( Event.ENTER_FRAME, onEF, false );
			queue = queue.reverse();
			while ( queue.length > 0 )
			{
				var delegateFn:Function = queue.pop();
				delegateFn();
			}
		}
	}
}