/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.mvcs
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IEventMap;
	
	/**
	 * Abstract MVCS <code>IActor</code> implementation
	 * 
	 * <p>As part of the MVCS implementation the <code>Actor</code> provides core functionality to an applications
	 * various working parts.</p>
	 * 
	 * <p>Some possible uses for the <code>Actor</code> include, but are no means limited to:</p>
	 * 
	 * <ul>
	 * <li>Service classes</li>
	 * <li>Model classes</li>
	 * <li>Controller classes</li>
	 * <li>Presentation model classes</li>
	 * </ul>
	 * 
	 * <p>Essentially in class where it might be advantagous to have basic dependency injection supplied is a candidate
	 * for extending <code>Actor</code>.</p>
	 * 
	 */
	public class Actor
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		protected var _eventMap:IEventMap;
		
		public function Actor()
		{
		}
		
		protected function get eventMap():IEventMap
		{
			return _eventMap || (_eventMap = new EventMap(eventDispatcher));
		}
		
		/**
		 * Dispatch helper method
		 *
		 * @param event The <code>Event</code> to dispatch on the <code>IContext</code>'s <code>IEventDispatcher</code>
		 */
		protected function dispatch(event:Event):Boolean
		{
 		    if(eventDispatcher.hasEventListener(event.type))
 		        return eventDispatcher.dispatchEvent(event);
 		 	return false;
		}
	}
}
