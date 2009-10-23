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
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	
	/**
	 * Abstract <code>IContext</code> implementation
	 */
	public class ContextBase implements IContext, IEventDispatcher
	{
		
		/**
		 * @private
		 */
		protected var _autoStartup:Boolean;
		
		/**
		 * @private
		 */
		protected var _commandMap:ICommandMap;
		
		/**
		 * @private
		 */
		protected var _contextView:DisplayObjectContainer;
		
		/**
		 * @private
		 */
		protected var _eventDispatcher:IEventDispatcher;
		
		/**
		 * @private
		 */
		protected var _initialized:Boolean;
		
		/**
		 * @private
		 */
		protected var _injector:IInjector;
		
		/**
		 * @private
		 */
		protected var _mediatorMap:IMediatorMap;
		
		/**
		 * @private
		 */
		protected var _reflector:IReflector;
		
		/**
		 * Default Context Implementation
		 *
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 * @param injector An Injector to use for this context
		 * @param reflector A Reflector to use for this context
		 */
		public function ContextBase(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true, injector:IInjector = null, reflector:IReflector = null)
		{
			_contextView = contextView;
			_autoStartup = autoStartup;
			_injector = injector;
			_reflector = reflector;
			if (_contextView)
			{
				initialize();
			}
		}
		
		/**
		 * The <code>IEventDispatcher</code> for this <code>IContext</code>
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
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
		 * <p>Note: This can only be set once</p>
		 *
		 * @param view The <code>DisplayObjectContainer</code> to use as scope for this <code>IContext</code>
		 */
		public function set contextView(value:DisplayObjectContainer):void
		{
			if (contextView)
			{
				throw new ContextError(ContextError.E_VIEW_OVR);
			}
			if (!value)
			{
				throw new ContextError(ContextError.E_VIEW_NULL);
			}
			_contextView = value;
			initialize();
		}
		
		/**
		 * The Startup Hook
		 *
		 * <p>Override this in your Framework Context implementation</p>
		 */
		public function startup():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
		}
		
		/**
		 * The Startup Hook
		 *
		 * <p>Override this in your Framework Context implementation</p>
		 */
		public function shutdown():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.SHUTDOWN_COMPLETE));
		}
		
		/**
		 * Default Context Initialization
		 *
		 * <p>Override this to intercept the default startup routine</p>
		 */
		protected function initialize():void
		{
			if (_initialized)
			{
				throw new ContextError(ContextError.E_INIT_OVR);
			}
			if (!_contextView)
			{
				throw new ContextError(ContextError.E_VIEW_NULL);
			}
			_eventDispatcher = new EventDispatcher(this);
			_injector = _injector || createInjector();
			_reflector = _reflector || createReflector();
			_commandMap = createCommandMap();
			_mediatorMap = createMediatorMap();
			initializeInjections();
			if (_autoStartup)
			{
				contextView.stage ? startup() : contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
		}
		
		/**
		 * ADDED_TO_STAGE event handler
		 *
		 * <p>Only used if <code>autoStart</code> is true but the <code>contextView</code> was not on Stage</p>
		 *
		 * @param e The Event
		 */
		protected function onAddedToStage(e:Event):void
		{
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			startup();
		}
		
		/**
		 * Create a default <code>IInjector</code>
		 *
		 * <p>Override this to change the default configuration</p>
		 *
		 * <p>NOTE: If an <code>IInjector</code> was provided via the super constructor this method won't get called</p>
		 *
		 * @return An <code>IInjector</code>
		 */
		protected function createInjector():IInjector
		{
			return new SwiftSuspendersInjector();
		}
		
		/**
		 * Create a default <code>IReflector</code>
		 *
		 * <p>Override this to change the default configuration</p>
		 *
		 * <p>NOTE: If an <code>IReflector</code> was provided via the super constructor this method won't get called</p>
		 *
		 * @return An <code>IReflector</code>
		 */
		protected function createReflector():IReflector
		{
			return new SwiftSuspendersReflector();
		}
		
		/**
		 * Create a default <code>ICommandMap</code>
		 *
		 * <p>Override this to change the default configuration</p>
		 *
		 * @return An <code>ICommandMap</code>
		 */
		protected function createCommandMap():ICommandMap
		{
			return new CommandMap(eventDispatcher, injector, reflector);
		}
		
		/**
		 * Create a default <code>IMediatorMap</code>
		 *
		 * <p>Override this to change the default configuration</p>
		 *
		 * @return An <code>IMediatorMap</code>
		 */
		protected function createMediatorMap():IMediatorMap
		{
			return new MediatorMap(contextView, injector, reflector);
		}
		
		/**
		 * Bind some commonly needed contextual dependencies for convenience
		 *
		 * <p>Override this to change the default (blank) configuration</p>
		 *
		 * <p>These should be named to avoid collisions</p>
		 */
		protected function initializeInjections():void
		{
		}
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>
		 */
		protected function get commandMap():ICommandMap
		{
			return _commandMap;
		}
		
		/**
		 * The <code>IInjector</code> for this <code>IContext</code>
		 */
		protected function get injector():IInjector
		{
			return _injector;
		}
		
		/**
		 * The <code>IMediatorMap</code> for this <code>IContext</code>
		 */
		protected function get mediatorMap():IMediatorMap
		{
			return _mediatorMap;
		}
		
		/**
		 * The <code>IReflector</code> for this <code>IContext</code>
		 */
		protected function get reflector():IReflector
		{
			return _reflector;
		}
		
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