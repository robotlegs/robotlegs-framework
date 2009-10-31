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
	 * An abstract <code>IContext</code> implementation
	 */
	public class ContextBase implements IContext, IEventDispatcher
	{
		
		protected var _autoStartup:Boolean;
		protected var _commandMap:ICommandMap;
		protected var _contextView:DisplayObjectContainer;
		protected var _eventDispatcher:IEventDispatcher;
		protected var _injector:IInjector;
		protected var _mediatorMap:IMediatorMap;
		protected var _reflector:IReflector;
		
		/**
		 * Default Context Implementation
		 *
		 * <p>Extend this class to create a Framework or Application context</p>
		 *
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 * @param injector An Injector to use for this context
		 * @param reflector A Reflector to use for this context
		 */
		public function ContextBase(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true, injector:IInjector = null, reflector:IReflector = null)
		{
			_eventDispatcher = new EventDispatcher(this);
			_contextView = contextView;
			_autoStartup = autoStartup;
			_injector = injector;
			_reflector = reflector;
			initialize();
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
		 * The <code>IEventDispatcher</code> for this <code>IContext</code>
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
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
				mediatorMap.contextView = value;
				mapInjections();
				checkAutoStartup();
			}
		}
		
		/**
		 * The <code>DisplayObjectContainer</code> that scopes this <code>IContext</code>
		 */
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}
		
		// CPI ////////////////////////////////////////////////////////////////
		
		/**
		 * Initialize the Framework apparatus
		 *
		 * <p>Override this in your Framework or Application context to alter the default (fallback) apparatus</p>
		 *
		 * <p>NOTE: be sure to call <code>super.initialize()</code> at the end to proceed with the the Injection Mapping and autoStartup check</p>
		 *
		 * <p>You might however decide to completely intercept the startup check should you so wish</p>
		 */
		protected function initialize():void
		{
			mapInjections();
			checkAutoStartup();
		}
		
		/**
		 * Bind some commonly needed contextual dependencies for convenience
		 *
		 * <p>Override this in your Framework context to change the default (blank) configuration</p>
		 *
		 * <p>Beware of collisions in your container</p>
		 */
		protected function mapInjections():void
		{
		}
		
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
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			startup();
		}
		
		// FPI ////////////////////////////////////////////////////////////////
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>
		 */
		protected function set commandMap(value:ICommandMap):void
		{
			_commandMap = value;
		}
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>
		 */
		protected function get commandMap():ICommandMap
		{
			return _commandMap || (_commandMap = new CommandMap(eventDispatcher, injector, reflector));
		}
		
		/**
		 * The <code>IInjector</code> for this <code>IContext</code>
		 */
		protected function set injector(value:IInjector):void
		{
			_injector = value;
		}
		
		/**
		 * The <code>IInjector</code> for this <code>IContext</code>
		 */
		protected function get injector():IInjector
		{
			return _injector || (_injector = new SwiftSuspendersInjector());
		}
		
		/**
		 * The <code>IMediatorMap</code> for this <code>IContext</code>
		 */
		protected function set mediatorMap(value:IMediatorMap):void
		{
			_mediatorMap = value;
		}
		
		/**
		 * The <code>IMediatorMap</code> for this <code>IContext</code>
		 */
		protected function get mediatorMap():IMediatorMap
		{
			return _mediatorMap || (_mediatorMap = new MediatorMap(contextView, injector, reflector));
		}
		
		/**
		 * The <code>IReflector</code> for this <code>IContext</code>
		 */
		protected function set reflector(value:IReflector):void
		{
			_reflector = value;
		}
		
		/**
		 * The <code>IReflector</code> for this <code>IContext</code>
		 */
		protected function get reflector():IReflector
		{
			return _reflector || (_reflector = new SwiftSuspendersReflector());
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
