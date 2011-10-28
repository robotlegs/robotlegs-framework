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
	
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	
	/**
	 * Abstract MVCS command implementation
	 */
	public class Command
	{
		[Inject]
		public var contextView:DisplayObjectContainer;
		
		[Inject]
		public var commandMap:ICommandMap;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		public function Command()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
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