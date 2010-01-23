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
	
	import org.flexunit.Assert;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.mvcs.support.CustomEvent;
	
	public class EventMapTests
	{
		protected var eventDispatcher:IEventDispatcher;
		protected var eventMap:IEventMap;
		protected var listenerExecuted:Boolean;
		protected var listenerExecutedCount:uint;
		
		[Before]
		public function runBeforeEachTest():void
		{
			eventDispatcher = new EventDispatcher();
			eventMap = new EventMap(eventDispatcher);
		}
		
		[After]
		public function runAfterEachTest():void
		{
			resetListenerExecuted();
			resetListenerExecutedCount();
		}
		
		[Test]
		public function noListener():void
		{
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertFalse('Listener should NOT have reponded to event', listenerExecuted);
		}
		
		[Test]
		public function mapListenerNormal():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			Assert.assertTrue('Listener should have reponded to plain event', listenerExecuted);
			resetListenerExecuted();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Listener should have reponded to strong event', listenerExecuted);
		}
		
		[Test]
		public function mapListenerStrong():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			Assert.assertFalse('Listener should NOT have reponded to plain event', listenerExecuted);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Listener should have reponded to strong event', listenerExecuted);
		}
		
		[Test]
		public function mapListenerTwice():void {
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, mapListenerTwiceListener, CustomEvent);
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, mapListenerTwiceListener, CustomEvent);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertEquals('Listener should have only responded once', 1, listenerExecutedCount);
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, mapListenerTwiceListener, CustomEvent);
			resetListenerExecutedCount();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertEquals('Listener should NOT have responded', 0, listenerExecutedCount);
		}
		
		[Test]
		public function unmapListenerNormal():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			Assert.assertFalse('Listener should NOT have reponded to plain event', listenerExecuted);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertFalse('Listener should NOT have reponded to strong event', listenerExecuted);
		}
		
		[Test]
		public function unmapListenerStrong():void
		{
			// Map to a concrete Event Class
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			// Unmap, but not the concrete Event Class
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener);
			// Dispatch Event of concrete type
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			// Should still respond
			Assert.assertTrue('Listener should have reponded to strong event', listenerExecuted);
			// Reset
			resetListenerExecuted();
			// Unmap, but this time specifiy the Event Class
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			// Dispatch Event of concrete type
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			// Should no longer respond
			Assert.assertFalse('Listener should NOT have reponded to strong event', listenerExecuted);
		}
		
		[Test]
		public function unmapListeners():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			eventMap.unmapListeners();
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			Assert.assertFalse('Listener should NOT have reponded to plain event', listenerExecuted);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertFalse('Listener should NOT have reponded to strong event', listenerExecuted);
		}
		
		// Helpers
		protected function listener(e:Event):void
		{
			listenerExecuted = true;
		}
		
		protected function resetListenerExecuted():void
		{
			listenerExecuted = false;
		}
		
		protected function mapListenerTwiceListener(e:Event):void {
			listenerExecutedCount++;
		}
		protected function resetListenerExecutedCount():void {
			listenerExecutedCount = 0;
		}
	}
}
