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
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	
	/**
	 * An abstract <code>IContext</code> implementation
	 */
	public class ContextBase implements IContext, IEventDispatcher
	{
		protected var _autoStartup:Boolean;
		
		protected var _contextView:DisplayObjectContainer;
		protected var _eventDispatcher:IEventDispatcher;
		protected var _injector:IInjector;
		protected var _reflector:IReflector;
		
		/**
		 * Abstract Context Implementation
		 *
		 * <p>Extend this class to create a Framework or Application context</p>
		 *
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 */
		public function ContextBase(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			_eventDispatcher = new EventDispatcher(this);
			_contextView = contextView;
			_autoStartup = autoStartup;
			mapInjections();
			checkAutoStartup();
		}
		
		// API ////////////////////////////////////////////////////////////////
		
		/**
		 * The Startup Hook
		 *
		 * <p>Override this in your Application context</p>
		 */
		public function startup():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
		}
		
		/**
		 * The Startup Hook
		 *
		 * <p>Override this in your Application context</p>
		 */
		public function shutdown():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.SHUTDOWN_COMPLETE));
		}
		
		/**
		 * The <code>DisplayObjectContainer</code> that scopes this <code>IContext</code>
		 */
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}
		
		/**
		 * The <code>IContext</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @param view The <code>DisplayObjectContainer</code> to use as scope for this <code>IContext</code>
		 */
		public function set contextView(value:DisplayObjectContainer):void
		{
			if (_contextView != value)
			{
				_contextView = value;
				mapInjections();
				checkAutoStartup();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
		}
		
		// FPI ////////////////////////////////////////////////////////////////
		
		/**
		 * The <code>IInjector</code> for this <code>IContext</code>
		 */
		protected function set injector(value:IInjector):void
		{
			_injector = value;
		}
		
		/**
		 * @inheritDoc
		 */
		protected function get injector():IInjector
		{
			return _injector || (_injector = new SwiftSuspendersInjector());
		}
		
		/**
		 * The <code>IReflector</code> for this <code>IContext</code>
		 */
		protected function set reflector(value:IReflector):void
		{
			_reflector = value;
		}
		
		/**
		 * @inheritDoc
		 */
		protected function get reflector():IReflector
		{
			return _reflector || (_reflector = new SwiftSuspendersReflector());
		}
		
		// Hooks //////////////////////////////////////////////////////////////
		
		/**
		 * Injection Mapping Hook
		 *
		 * <p>Override this in your Framework context to change the default configuration</p>
		 *
		 * <p>Beware of collisions in your container</p>
		 */
		protected function mapInjections():void
		{
		}
		
		// Internal ///////////////////////////////////////////////////////////
		
		/**
		 * @private
		 */
		protected function checkAutoStartup():void
		{
			if (_autoStartup && contextView)
			{
				contextView.stage ? startup() : contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
		}
		
		/**
		 * @private
		 */
		protected function onAddedToStage(e:Event):void
		{
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			startup();
		}
		
		// EventDispatcher Boilerplate ////////////////////////////////////////
		
		/**
		 * @private
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, useCapture, priority);
		}
		
		/**
		 * @private
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
		
		/**
		 * @private
		 */
		public function hasEventListener(type:String):Boolean
		{
			return eventDispatcher.hasEventListener(type);
		}
		
		/**
		 * @private
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * @private
		 */
		public function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
	}
}
