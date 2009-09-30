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
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.impl.NullLogger;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	
	/**
	 * Abstract MVCS <code>IContext</code> implementation
	 */
	public class Context implements IContext
	{
		protected var contextView:DisplayObjectContainer;
		protected var logger:ILogger;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var commandMap:ICommandMap;
		protected var eventDispatcher:IEventDispatcher;
		protected var eventBroadcaster:IEventBroadcaster;
		protected var mediatorMap:IMediatorMap;
		
		/**
		 * Default Context Implementation
		 *
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param injector An Injector to use for this context
		 * @param reflector A Reflector to use for this context
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 */
		public function Context(contextView:DisplayObjectContainer, injector:IInjector = null, reflector:IReflector = null, autoStartup:Boolean = true)
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
		 *
		 * Call <code>super.startup()</code> if you want to log the occasion.
		 */
		public function startup():void
		{
			logger.info('Context Starting Up - ' + this);
			eventBroadcaster.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
		
		/**
		 * Return this <code>Context</code>'s IEventDispatcher
		 *
		 * @return The <code>Context</code>'s IEventDispatcher
		 */
		public function getEventDispatcher():IEventDispatcher
		{
			return eventDispatcher;
		}
		
		/**
		 * Internal
		 */
		protected function initialize(autoStartup:Boolean):void
		{
			if (injector == null)
			{
				injector = createInjector();
			}
			if (reflector == null)
			{
				reflector = createReflector();
			}
			logger = createLogger();
			eventDispatcher = createEventDispatcher();
			eventBroadcaster = createEventBroadcaster();
			commandMap = createCommandMap();
			mediatorMap = createMediatorMap();
			initializeInjections();
			logger.info('Context Initialized - ' + this);
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
			logger.info('contextView has been added to the stage');
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
		 * Create a default <code>ILogger</code>
		 * 
		 * Override this to change the default configuration
		 * 
		 * @return An <code>ILogger</code>
		 */		
		protected function createLogger():ILogger
		{
			return new NullLogger();
		}
		
		/**
		 * Create a default <code>IEventDispatcher</code>
		 * 
		 * Override this to change the default configuration
		 * 
		 * @return An <code>IEventDispatcher</code>
		 */		
		protected function createEventDispatcher():IEventDispatcher
		{
			return new EventDispatcher();
		}
		
		/**
		 * Create a default <code>IEventBroadcaster</code>
		 * 
		 * Override this to change the default configuration
		 * 
		 * @return An <code>IEventBroadcaster</code>
		 */		
		protected function createEventBroadcaster():IEventBroadcaster
		{
			return new EventBroadcaster(eventDispatcher);
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
			return new CommandMap(eventDispatcher, injector, reflector, logger);
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
			return new MediatorMap(contextView, injector, reflector, logger);
		}
		
		/**
		 * Bind some commonly needed contextual dependencies for convenience
		 *
		 * These are named to avoid collisions
		 */
		protected function initializeInjections():void
		{
			injector.bindValue(DisplayObjectContainer, contextView, 'mvcsContextView');
			injector.bindValue(ILogger, logger, 'mvcsLogger');
			injector.bindValue(IInjector, injector, 'mvcsInjector');
			injector.bindValue(IEventDispatcher, eventDispatcher, 'mvcsEventDispatcher');
			injector.bindValue(IEventBroadcaster, eventBroadcaster, 'mvcsEventBroadcaster');
			injector.bindValue(ICommandMap, commandMap, 'mvcsCommandMap');
			injector.bindValue(IMediatorMap, mediatorMap, 'mvcsMediatorMap');
		}
		
		/**
		 * dispatchEvent Helper method
		 *
		 * The same as calling <code>dispatchEvent</code> directly on the <code>IEventDispatcher</code>.
		 *
		 * @param event The <code>Event</code> to dispatch on the <code>IEventDispatcher</code>
		 */
		protected function dispatch(event:Event):void
		{
			eventDispatcher.dispatchEvent(event);
		}
	}
}