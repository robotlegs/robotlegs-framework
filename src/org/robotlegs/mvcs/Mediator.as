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
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
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
	
		protected function get eventMap():IEventMap
		{
			return _eventMap || (_eventMap = new EventMap(eventDispatcher));
		}
		
		/**
		 * Dispatch helper method
		 *
		 * @param event The Event to dispatch on the <code>IContext</code>'s <code>IEventDispatcher</code>
		 */
		protected function dispatch(event:Event):void
		{
			eventDispatcher.dispatchEvent(event);
		}
		
	}
}
