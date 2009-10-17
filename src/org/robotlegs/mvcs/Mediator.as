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

package org.robotlegs.mvcs
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.base.MediatorBase;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IPropertyProvider;
	
	/**
	 * Abstract MVCS <code>IMediator</code> and <code>IPropertyProvider</code> implementation
	 */
	public class Mediator extends MediatorBase implements IPropertyProvider
	{
		[Inject(name='mvcsContextView')]
		public var contextView:DisplayObjectContainer;
		
		[Inject(name='mvcsMediatorMap')]
		public var mediatorMap:IMediatorMap;
		
		[Inject(name='mvcsEventDispatcher')]
		public var eventDispatcher:IEventDispatcher;
		
		/**
		 * Internal
		 *
		 * A list of currently registered listeners
		 */
		protected var listeners:Array;
		
		public function Mediator()
		{
			listeners = new Array();
		}
		
		/**
		 * Walk up the Display List looking for view components that have corresponding Mediators in this Context
		 * Ask each Mediator for a named, typed property, and return the first non-null result
		 *
		 * This mechanism is evil. A better solution to the "Robot Legs" problem is sorely needed.
		 *
		 * @param name The name of the property you are looking for
		 * @param type The type of property you are looking for
		 * @return The returned value
		 */
		public function findProperty(name:String, type:*):*
		{
			var val:*;
			var viewDo:DisplayObject = getViewComponent() as DisplayObject;
			var parent:DisplayObjectContainer;
			var parentMediator:IMediator;
			var parentProvider:IPropertyProvider;
			while ((parent = viewDo.parent))
			{
				if ((parentMediator = mediatorMap.retrieveMediator(parent)))
				{
					if ((parentProvider = parentMediator as IPropertyProvider) && (val = parentProvider.provideProperty(name, type)))
					{
						return val;
					}
				}
				viewDo = parent;
			}
			return null;
		}
		
		/**
		 * TODO: document
		 */
		public function provideProperty(name:String, type:*):*
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function preRemove():void
		{
			removeListeners();
			super.preRemove();
		}
		
		/**
		 * addEventListener Helper method
		 *
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
		protected function addEventListenerTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			// TODO: make weak - currently the listeners array keeps strong references.. bad
			var params:Object = {dispatcher: dispatcher, type: type, listener: listener, useCapture: useCapture};
			listeners.push(params);
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * removeEventListener Helper method
		 *
		 * The same as calling <code>removeEventListener</code> directly on the <code>IEventDispatcher</code>,
		 * but updates our local list of listeners.
		 *
		 * @param dispatcher The <code>IEventDispatcher</code>
		 * @param type The <code>Event</code> type
		 * @param listener The <code>Event</code> handler
		 * @param useCapture
		 */
		protected function removeEventListenerFrom(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false):void
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
		 * Removes all listeners registered through <code>addEventListenerTo</code>
		 */
		protected function removeListeners():void
		{
			var params:Object;
			var dispatcher:IEventDispatcher;
			while (params = listeners.pop())
			{
				dispatcher = params.dispatcher;
				dispatcher.removeEventListener(params.type, params.listener, params.useCapture);
			}
		}
		
		/**
		 * dispatchEvent Helper method
		 *
		 * The same as calling <code>dispatchEvent</code> directly on the <code>IEventDispatcher</code>.
		 *
		 * @param event The <code>Event</code> to dispatch on the <code>IEventDispatcher</code>
		 */
		protected function dispatchEvent(event:Event):void
		{
			eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * Relays an event to the framework. This is used when your view component is dispatching
		 * an event that simply needs broadcast. 
		 * 
		 * @param event The <code>Event</code> to relay to the framework
		 * 
		 */		
		protected function relayEvent(event:Event):void
		{
			dispatchEvent(event);
		}
	
	}
}