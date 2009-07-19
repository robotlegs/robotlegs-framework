package org.robotlegs.utils
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class DelayedFunctionQueue
	{
		private static var instance:DelayedFunctionQueue;
		protected var queue:Array;
		protected var dispatcher:Sprite;

		/**
		 * A utility to call functions on the next Flash Player frame
		 */
		public function DelayedFunctionQueue()
		{
			queue = new Array();
			dispatcher = new Sprite();
		}

		/**
		 * Add a function, with optional arguments, to be called on the next Flash Player frame
		 * @param func The function to execute
		 * @param args Optional function arguments
		 */
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

		/**
		 * Add a function, with optional arguments, to be called on the next Flash Player frame
		 * @param func The function to execute
		 * @param args Optional function arguments
		 */
		public static function add( func:Function, ... args ):void
		{
			instance = instance ? instance : new DelayedFunctionQueue();
			instance.add.apply( null, [ func ].concat( args ) );
		}

		/**
		 * The Enter Frame Event Handler
		 * @param event The Event
		 */
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