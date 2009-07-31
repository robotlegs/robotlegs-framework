/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.robotlegs.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * A utility to call functions on the next Flash Player frame
	 */
	public class DelayedFunctionQueue
	{
		/**
		 * Internal
		 * Singleton <code>DelayedFunctionQueue</code> instance
		 */
		private static var instance:DelayedFunctionQueue;
		
		/**
		 * Internal
		 * An ordered <code>Array</code> of function closures to call on the next Frame
		 */
		protected var queue:Array;
		
		/**
		 * Internal
		 * A <code>Sprite</code>
		 */
		protected var dispatcher:Sprite;
		
		/**
		 * Creates a new <code>DelayedFunctionQueue</code> object
		 */
		public function DelayedFunctionQueue()
		{
			queue = new Array();
			dispatcher = new Sprite();
		}
		
		/**
		 * Add a function, with optional arguments, to be called on the next Flash Player frame
		 * @param func The function to execute on the next Flash Player frame
		 * @param args Optional function arguments
		 */
		public function add(func:Function, ... args):void
		{
			var delegateFn:Function = function():void
			{
				func.apply(null, args);
			}
			queue.push(delegateFn);
			if (queue.length == 1)
			{
				dispatcher.addEventListener(Event.ENTER_FRAME, onEF, false, 0, true);
			}
		}
		
		/**
		 * Add a function, with optional arguments, to be called on the next Flash Player frame
		 *
		 * The static Singleton approach
		 *
		 * @param func The function to execute on the next Flash Player frame
		 * @param args Optional function arguments
		 */
		public static function add(func:Function, ... args):void
		{
			instance = instance ? instance : new DelayedFunctionQueue();
			instance.add.apply(null, [func].concat(args));
		}
		
		/**
		 * The Enter Frame Event Handler
		 * @param event The Event
		 */
		protected function onEF(event:Event):void
		{
			dispatcher.removeEventListener(Event.ENTER_FRAME, onEF, false);
			queue = queue.reverse();
			while (queue.length > 0)
			{
				var delegateFn:Function = queue.pop();
				delegateFn();
			}
		}
	}
}