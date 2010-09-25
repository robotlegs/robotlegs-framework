/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
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
		
		/**
		 * @private
		 */
		protected var _dispatcherListeningEnabled:Boolean = true;
		
		/**
		 * @private
		 */
		protected var listeners:Array;
		
		//---------------------------------------------------------------------
		//  Constructor
		//---------------------------------------------------------------------
		
		/**
		 * Creates a new <code>EventMap</code> object
		 *
		 * @param eventDispatcher An <code>IEventDispatcher</code> to treat as a bus
		 */
		public function EventMap(eventDispatcher:IEventDispatcher)
		{
			listeners = new Array();
			this.eventDispatcher = eventDispatcher;
		}
		
		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------
		
		/**
		 * @return Is shared dispatcher listening allowed?
		 */
		public function get dispatcherListeningEnabled():Boolean
		{
			return _dispatcherListeningEnabled;
		}
		
		/**
		 * @private
		 */
		public function set dispatcherListeningEnabled(value:Boolean):void
		{
			_dispatcherListeningEnabled = value;
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
			eventClass ||= Event;
			
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
					return;
				}
			}
			
			var callback:Function = function(event:Event):void
				{
					routeEventToListener(event, listener, eventClass);
				};
			params = {
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
			eventClass ||= Event;
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
		
		//---------------------------------------------------------------------
		//  Internal
		//---------------------------------------------------------------------
		
		/**
		 * Event Handler
		 *
		 * @param event The <code>Event</code>
		 * @param listener
		 * @param originalEventClass
		 */
		protected function routeEventToListener(event:Event, listener:Function, originalEventClass:Class):void
		{
			if (event is originalEventClass)
			{
				listener(event);
			}
		}
	}
}
