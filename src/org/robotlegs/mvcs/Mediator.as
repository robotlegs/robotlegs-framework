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
	
	import org.robotlegs.base.EventMap;
	import org.robotlegs.base.MediatorBase;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.core.IMediatorMap;
	
	/**
	 * Abstract MVCS <code>IMediator</code> implementation
	 */
	public class Mediator extends MediatorBase
	{
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		/**
		 * @private
		 */
		protected var _eventDispatcher:IEventDispatcher;
		
		/**
		 * @private
		 */
		protected var _eventMap:IEventMap;
		
		public function Mediator()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		override public function preRemove():void
		{
			if (_eventMap)
				_eventMap.unmapListeners();
			super.preRemove();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
		}
		
		[Inject]
		/**
		 * @private
		 */
		public function set eventDispatcher(value:IEventDispatcher):void
		{
			_eventDispatcher = value;
		}
		
		/**
		 * Local EventMap
		 *
		 * @return The EventMap for this Actor
		 */
		protected function get eventMap():IEventMap
		{
			return _eventMap || (_eventMap = new EventMap(eventDispatcher));
		}
		
		/**
		 * Dispatch helper method
		 *
		 * @param event The Event to dispatch on the <code>IContext</code>'s <code>IEventDispatcher</code>
		 */
		protected function dispatch(event:Event):Boolean
		{
 		    if(eventDispatcher.hasEventListener(event.type))
 		        return eventDispatcher.dispatchEvent(event);
 		 	return false;
		}
		
		/**
		 * Syntactical sugar for mapping a listener to the <code>viewComponent</code> 
		 * 
		 * @param type
		 * @param listener
		 * @param eventClass
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		protected function addViewListener(type:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			eventMap.mapListener(IEventDispatcher(viewComponent), type, listener, 
				eventClass, useCapture, priority, useWeakReference); 
		}

        /**
		 * Syntactical sugar for mapping a listener from the <code>viewComponent</code>
		 *
		 * @param type
		 * @param listener
		 * @param eventClass
		 * @param useCapture
		 *
		 */
		protected function removeViewListener(type:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false):void
		{
			eventMap.unmapListener(IEventDispatcher(viewComponent), type, listener,
				eventClass, useCapture);
		}

		/**
		 * Syntactical sugar for mapping a listener to an <code>IEventDispatcher</code> 
		 * 
		 * @param dispatcher
		 * @param type
		 * @param listener
		 * @param eventClass
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * 
		 */		
		protected function addContextListener(type:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
	 	{
			eventMap.mapListener(eventDispatcher, type, listener, 
				eventClass, useCapture, priority, useWeakReference); 									   
		}

		/**
		 * Syntactical sugar for unmapping a listener from an <code>IEventDispatcher</code>
		 *
		 * @param dispatcher
		 * @param type
		 * @param listener
		 * @param eventClass
		 * @param useCapture
		 *
		 */
		protected function removeContextListener(type:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false):void
	 	{
			eventMap.unmapListener(eventDispatcher, type, listener,
				eventClass, useCapture);
		}
	}
}
