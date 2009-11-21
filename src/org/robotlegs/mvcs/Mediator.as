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
			eventMap.unmapListeners();
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
	
	}
}
