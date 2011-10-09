/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.base.ContextBase;
	import org.robotlegs.base.ContextError;
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.base.MediatorMap;
	import org.robotlegs.base.ViewMap;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.IViewMap;
	
	/**
	 * Dispatched by the <code>startup()</code> method when it finishes
	 * executing.
	 * 
	 * <p>One common pattern for application startup/bootstrapping makes use
	 * of the <code>startupComplete</code> event. In this pattern, you do the
	 * following:</p>
	 * <ul>
	 *   <li>Override the <code>startup()</code> method in your Context 
	 *       subclass and set up application mappings in your 
	 *       <code>startup()</code> override as you always do in Robotlegs.</li>
	 *   <li>Create commands that perform startup/bootstrapping operations
	 *       such as loading the initial data, checking for application updates,
	 *       etc.</li>
	 *   <li><p>Map those commands to the <code>ContextEvent.STARTUP_COMPLETE</code>
	 *       event:</p>
	 *       <listing>commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, LoadInitialDataCommand, ContextEvent, true):</listing>
	 *       </li>
	 *   <li>Dispatch the <code>startupComplete</code> (<code>ContextEvent.STARTUP_COMPLETE</code>)
	 *       event from your <code>startup()</code> override. You can do this
	 *       in one of two ways: dispatch the event yourself, or call 
	 *       <code>super.startup()</code>. (The Context class's 
	 *       <code>startup()</code> method dispatches the 
	 *       <code>startupComplete</code> event.)</li>
	 * </ul>
	 * 
	 * @eventType org.robotlegs.base.ContextEvent.STARTUP_COMPLETE
	 * 
	 * @see #startup()
	 */
	[Event(name="startupComplete", type="org.robotlegs.base.ContextEvent")]
	
	
	/**
	 * Abstract MVCS <code>IContext</code> implementation
	 */
	public class Context extends ContextBase implements IContext
	{
		
		/**
		 * @private
		 */
		protected var _injector:IInjector;
		
		/**
		 * @private
		 */
		protected var _reflector:IReflector;
		
		/**
		 * @private
		 */
		protected var _autoStartup:Boolean;
		
		/**
		 * @private
		 */
		protected var _contextView:DisplayObjectContainer;
		
		/**
		 * @private
		 */
		protected var _commandMap:ICommandMap;
		
		/**
		 * @private
		 */
		protected var _mediatorMap:IMediatorMap;
		
		/**
		 * @private
		 */
		protected var _viewMap:IViewMap;
		
		//---------------------------------------------------------------------
		//  Constructor
		//---------------------------------------------------------------------
		
		/**
		 * Abstract Context Implementation
		 *
		 * <p>Extend this class to create a Framework or Application context</p>
		 *
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 */
		public function Context(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super();
			
			_contextView = contextView;
			_autoStartup = autoStartup;
			
			if (_contextView)
			{
				mapInjections();
				checkAutoStartup();
			}
		}
		
		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------
		
		/**
		 * The Startup Hook
		 *
		 * <p>Override this in your Application context</p>
		 * 
		 * @event startupComplete ContextEvent.STARTUP_COMPLETE Dispatched at the end of the
		 *                        <code>startup()</code> method's execution. This
		 *                        is often used to trigger startup/bootstrapping
		 *                        commands by wiring them to this event and 
		 *                        calling <code>super.startup()</code> in the 
		 *                        last line of your <code>startup()</code>
		 *                        override.
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
		 * @private
		 */
		public function set contextView(value:DisplayObjectContainer):void
		{
			if (value == _contextView)
				return;
			
			if (_contextView)
				throw new ContextError(ContextError.E_CONTEXT_VIEW_OVR);
			
			_contextView = value;
			mapInjections();
			checkAutoStartup();
		}
		
		//---------------------------------------------------------------------
		//  Protected, Lazy Getters and Setters
		//---------------------------------------------------------------------
		
		/**
		 * The <code>IInjector</code> for this <code>IContext</code>
		 */
		protected function get injector():IInjector
		{
			return _injector ||= createInjector();
		}
		
		/**
		 * @private
		 */
		protected function set injector(value:IInjector):void
		{
			_injector = value;
		}
		
		/**
		 * The <code>IReflector</code> for this <code>IContext</code>
		 */
		protected function get reflector():IReflector
		{
			return _reflector ||= new SwiftSuspendersReflector();
		}
		
		/**
		 * @private
		 */
		protected function set reflector(value:IReflector):void
		{
			_reflector = value;
		}
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>
		 */
		protected function get commandMap():ICommandMap
		{
			return _commandMap ||= new CommandMap(eventDispatcher, createChildInjector(), reflector);
		}
		
		/**
		 * @private
		 */
		protected function set commandMap(value:ICommandMap):void
		{
			_commandMap = value;
		}
		
		/**
		 * The <code>IMediatorMap</code> for this <code>IContext</code>
		 */
		protected function get mediatorMap():IMediatorMap
		{
			return _mediatorMap ||= new MediatorMap(contextView, createChildInjector(), reflector);
		}
		
		/**
		 * @private
		 */
		protected function set mediatorMap(value:IMediatorMap):void
		{
			_mediatorMap = value;
		}
		
		/**
		 * The <code>IViewMap</code> for this <code>IContext</code>
		 */
		protected function get viewMap():IViewMap
		{
			return _viewMap ||= new ViewMap(contextView, injector);
		}
		
		/**
		 * @private
		 */
		protected function set viewMap(value:IViewMap):void
		{
			_viewMap = value;
		}
		
		//---------------------------------------------------------------------
		//  Framework Hooks
		//---------------------------------------------------------------------
		
		/**
		 * Injection Mapping Hook
		 *
		 * <p>Override this in your Framework context to change the default configuration</p>
		 *
		 * <p>Beware of collisions in your container</p>
		 */
		protected function mapInjections():void
		{
			injector.mapValue(IReflector, reflector);
			injector.mapValue(IInjector, injector);
			injector.mapValue(IEventDispatcher, eventDispatcher);
			injector.mapValue(DisplayObjectContainer, contextView);
			injector.mapValue(ICommandMap, commandMap);
			injector.mapValue(IMediatorMap, mediatorMap);
			injector.mapValue(IViewMap, viewMap);
			injector.mapClass(IEventMap, EventMap);
		}
		
		//---------------------------------------------------------------------
		//  Internal
		//---------------------------------------------------------------------
		
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
		
		/**
		 * @private
		 */
		protected function createInjector():IInjector
		{
			var injector:IInjector = new SwiftSuspendersInjector();
			injector.applicationDomain = getApplicationDomainFromContextView();
			return injector;
		}
		
		/**
		 * @private
		 */
		protected function createChildInjector():IInjector
		{
			return injector.createChild(getApplicationDomainFromContextView());
		}
		
		/**
		 * @private
		 */
		protected function getApplicationDomainFromContextView():ApplicationDomain
		{
			if (contextView && contextView.loaderInfo)
				return contextView.loaderInfo.applicationDomain;
			return ApplicationDomain.currentDomain;
		}
	
	}
}