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
	
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	
	/**
	 * Abstract <code>IContext</code> implementation
	 * 
	 * A 
	 * 
	 */
	public class ContextBase extends EventDispatcher implements IContext
	{
		/**
		 * The context <code>DisplayObjectContainer</code>
		 */
		protected var contextView:DisplayObjectContainer;
		
		/**
		 * The context <code>IInjector</code>
		 */
		protected var injector:IInjector;
		
		/**
		 * The context <code>IReflector</code>
		 */
		protected var reflector:IReflector;
		
		/**
		 * The context <code>ICommandMap</code>
		 */
		protected var commandMap:ICommandMap;
		
		/**
		 * The context <code>IMediatorMap</code>
		 */
		protected var mediatorMap:IMediatorMap;
		
		/**
		 * Default Context Implementation
		 *
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 * @param injector An Injector to use for this context
		 * @param reflector A Reflector to use for this context
		 */
		public function ContextBase(contextView:DisplayObjectContainer, autoStartup:Boolean = true, injector:IInjector = null, reflector:IReflector = null)
		{
			this.contextView = contextView;
			this.injector = injector;
			this.reflector = reflector;
			initialize(autoStartup);
		}
		
		/**
		 * The Startup Hook
		 *
		 * Override this in your implementation
		 */
		public function startup():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
		}
		
		/**
		 * The Startup Hook
		 *
		 * Override this in your implementation
		 */
		public function shutdown():void
		{
			dispatchEvent(new ContextEvent(ContextEvent.SHUTDOWN_COMPLETE));
		}
		
		/**
		 * Default Context Initialization
		 * 
		 * Override this to intercept the default startup routine
		 */
		protected function initialize(autoStartup:Boolean):void
		{
			injector = injector || createInjector();
			reflector = reflector || createReflector();
			commandMap = createCommandMap();
			mediatorMap = createMediatorMap();
			initializeInjections();
			if (autoStartup)
			{
				contextView.stage ? startup() : contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
		}
		
		/**
		 * ADDED_TO_STAGE event handler
		 *
		 * Only used if <code>autoStart</code> is true but the <code>contextView</code> was not on Stage during the context's construction
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
		 * Override this to change the default configuration
		 *
		 * NOTE: If an <code>IInjector</code> was provided via the super constructor this method won't get called
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
		 * Override this to change the default configuration
		 *
		 * NOTE: If an <code>IReflector</code> was provided via the super constructor this method won't get called
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
		 * Override this to change the default configuration
		 *
		 * @return An <code>ICommandMap</code>
		 */
		protected function createCommandMap():ICommandMap
		{
			return new CommandMap(this, injector, reflector);
		}
		
		/**
		 * Create a default <code>IMediatorMap</code>
		 *
		 * Override this to change the default configuration
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
		 * Override this to change the default (blank) configuration
		 *
		 * These should be named to avoid collisions
		 */
		protected function initializeInjections():void
		{
		}
	
	}
}