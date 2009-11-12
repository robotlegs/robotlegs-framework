/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
{
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
		/**
		 * @private
		 */
		protected var _eventDispatcher:IEventDispatcher;
		
		/**
		 * @private
		 */
		protected var _injector:IInjector;
		
		/**
		 * @private
		 */
		protected var _reflector:IReflector;
		
		//---------------------------------------------------------------------
		//  Constructor
		//---------------------------------------------------------------------
		
		/**
		 * Abstract Context Implementation
		 *
		 * <p>Extend this class to create a Framework or Application context</p>
		 */
		public function ContextBase()
		{
			_eventDispatcher = new EventDispatcher(this);
		}
		
		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
		}
		
		//---------------------------------------------------------------------
		//  Protected, Lazy Getters and Setters
		//---------------------------------------------------------------------
		
		/**
		 * The <code>IInjector</code> for this <code>IContext</code>
		 */
		protected function get injector():IInjector
		{
			return _injector || (_injector = new SwiftSuspendersInjector());
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
			return _reflector || (_reflector = new SwiftSuspendersReflector());
		}
		
		/**
		 * @private
		 */
		protected function set reflector(value:IReflector):void
		{
			_reflector = value;
		}
		
		//---------------------------------------------------------------------
		//  EventDispatcher Boilerplate
		//---------------------------------------------------------------------
		
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
 		    if(eventDispatcher.hasEventListener(event.type))
 		        return eventDispatcher.dispatchEvent(event);
 		 	return false;
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
