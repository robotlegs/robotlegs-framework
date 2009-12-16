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
	
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.base.ContextBase;
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
	 * Abstract MVCS <code>IContext</code> implementation
	 */
	public class Context extends ContextBase implements IContext
	{
		
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
			mapInjections();
			checkAutoStartup();
		}
		
		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------
		
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
		 * @private
		 */
		public function set contextView(value:DisplayObjectContainer):void
		{
			if (_contextView != value)
			{
				_contextView = value;
				mediatorMap.contextView = value;
				viewMap.contextView = value;
				mapInjections();
				checkAutoStartup();
			}
		}
		
		//---------------------------------------------------------------------
		//  Protected, Lazy Getters and Setters
		//---------------------------------------------------------------------
		
		/**
		 * The <code>ICommandMap</code> for this <code>IContext</code>
		 */
		protected function get commandMap():ICommandMap
		{
			return _commandMap || (_commandMap = new CommandMap(eventDispatcher, injector, reflector));
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
			return _mediatorMap || (_mediatorMap = new MediatorMap(contextView, injector, reflector));
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
			return _viewMap || (_viewMap = new ViewMap(contextView, injector));
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
	
	}
}