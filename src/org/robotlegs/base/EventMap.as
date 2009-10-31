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
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.core.IEventMap;
	
	/**
	 * An abstract <code>IEventMap</code> implementation
	 */
	public class EventMap implements IEventMap
	{
		/**
		 * The <code>IEventDispatcher</code>
		 */
		protected var eventDispatcher:IEventDispatcher;
		
		protected var dispatcherListeningEnabled:Boolean;
		
		/**
		 * Internal
		 *
		 * A list of currently registered listeners
		 */
		protected var listeners:Array;
		
		public function EventMap(eventDispatcher:IEventDispatcher, dispatcherListeningEnabled:Boolean = true)
		{
			listeners = new Array();
			this.eventDispatcher = eventDispatcher;
			this.dispatcherListeningEnabled = dispatcherListeningEnabled;
		}
		
		/**
		 * The same as calling <code>addEventListener</code> directly on the <code>IEventDispatcher</code>,
		 * but keeps a list of listeners for easy (usually automatic) removal.
		 *
		 * @param dispatcher The <code>IEventDispatcher</code> to listen to
		 * @param type The <code>Event</code> type to listen for
		 * @param listener The <code>Event</code> handler
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>.
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 */
		public function mapListener(dispatcher:IEventDispatcher, type:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			if (dispatcherListeningEnabled == false && dispatcher == eventDispatcher)
			{
				throw new ContextError(ContextError.E_EVENTMAP_NOSNOOPING);
			}
			eventClass = eventClass || Event;
			var callback:Function = function(event:Event):void
				{
					routeEventToListener(event, listener, eventClass);
				};
			var params:Object = {
					dispatcher: dispatcher,
					type: type,
					listener: listener,
					eventClass: eventClass,
					callback: callback,
					useCapture: useCapture
				};
			listeners.push(params);
			dispatcher.addEventListener(type, callback, useCapture, priority, useWeakReference);
		}
		
		/**
		 * The same as calling <code>removeEventListener</code> directly on the <code>IEventDispatcher</code>,
		 * but updates our local list of listeners.
		 *
		 * @param dispatcher The <code>IEventDispatcher</code>
		 * @param type The <code>Event</code> type
		 * @param listener The <code>Event</code> handler
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>.
		 * @param useCapture
		 */
		public function unmapListener(dispatcher:IEventDispatcher, type:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false):void
		{
			eventClass = eventClass || Event;
			var params:Object;
			var i:int = listeners.length;
			while (i--)
			{
				params = listeners[i];
				if (params.dispatcher == dispatcher
					&& params.type == type
					&& params.listener == listener
					&& params.useCapture == useCapture
					&& params.eventClass == eventClass)
				{
					dispatcher.removeEventListener(type, params.callback, useCapture);
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
				dispatcher.removeEventListener(params.type, params.callback, params.useCapture);
			}
		}
		
		/**
		 * Event Handler
		 *
		 * @param event The <code>Event</code>
		 * @param commandClass The <code>ICommand</code> Class to construct and execute
		 * @param oneshot Should this command mapping be removed after execution?
		 */
		protected function routeEventToListener(event:Event, listener:Function, originalEventClass:Class):void
		{
			var eventClass:Class = Object(event).constructor;
			if (event is originalEventClass)
			{
				listener(event);
			}
		}
	}
}