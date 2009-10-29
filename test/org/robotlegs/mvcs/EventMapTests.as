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
	}
}