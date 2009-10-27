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

package org.robotlegs.base
{
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.core.IEventMap;
	
	public class EventMap implements IEventMap
	{
		/**
		 * The <code>IEventDispatcher</code>
		 */
		protected var eventDispatcher:IEventDispatcher;
		
		/**
		 * Internal
		 *
		 * A list of currently registered listeners
		 */
		protected var listeners:Array;
		
		public function EventMap(eventDispatcher:IEventDispatcher)
		{
			listeners = new Array();
			this.eventDispatcher = eventDispatcher;
		}
		
		/**
		 * The same as calling <code>addEventListener</code> directly on the <code>IEventDispatcher</code>,
		 * but keeps a list of listeners for easy (usually automatic) removal.
		 *
		 * @param dispatcher The <code>IEventDispatcher</code> to listen to
		 * @param type The <code>Event</code> type to listen for
		 * @param listener The <code>Event</code> handler
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 */
		public function mapListener(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			var params:Object = {dispatcher: dispatcher, type: type, listener: listener, useCapture: useCapture};
			listeners.push(params);
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * The same as calling <code>removeEventListener</code> directly on the <code>IEventDispatcher</code>,
		 * but updates our local list of listeners.
		 *
		 * @param dispatcher The <code>IEventDispatcher</code>
		 * @param type The <code>Event</code> type
		 * @param listener The <code>Event</code> handler
		 * @param useCapture
		 */
		public function unmapListener(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
		{
			var params:Object;
			var i:int = listeners.length;
			while (i--)
			{
				params = listeners[i];
				if (params.dispatcher == dispatcher && params.type == type && params.listener == listener && params.useCapture == useCapture)
				{
					dispatcher.removeEventListener(type, listener, useCapture);
					listeners.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * Removes all listeners registered through <code>mapListener</code>
		 */
		public function unmapListeners():void
		{
			var params:Object;
			var dispatcher:IEventDispatcher;
			while (params = listeners.pop())
			{
				dispatcher = params.dispatcher;
				dispatcher.removeEventListener(params.type, params.listener, params.useCapture);
			}
		}
	
	}
}