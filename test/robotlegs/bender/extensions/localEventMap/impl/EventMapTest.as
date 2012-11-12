//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.flexunit.asserts.*;
	import robotlegs.bender.extensions.localEventMap.api.IEventMap;
	import robotlegs.bender.extensions.localEventMap.impl.support.CustomEvent;

	public class EventMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var eventDispatcher:IEventDispatcher;

		private var eventMap:IEventMap;

		private var listenerExecuted:Boolean;

		private var listenerExecutedCount:uint;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function runBeforeEachTest():void
		{
			eventDispatcher = new EventDispatcher();
			eventMap = new EventMap();
		}

		[After]
		public function runAfterEachTest():void
		{
			resetListenerExecuted();
			resetListenerExecutedCount();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function listener_mapped_without_type_is_triggered_by_plain_Event():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			assertTrue(listenerExecuted);
		}

		[Test]
		public function listener_mapped_without_type_is_triggered_by_correct_typed_event():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			assertTrue(listenerExecuted);
		}

		[Test]
		public function listener_mapped_with_type_is_triggered_by_correct_typed_event():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			assertTrue(listenerExecuted);
		}

		[Test]
		public function listener_mapped_with_type_is_NOT_triggered_by_plain_event():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			assertFalse(listenerExecuted);
		}

		[Test]
		public function listener_mapped_twice_only_fires_once():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listenerWithCounter, CustomEvent);
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listenerWithCounter, CustomEvent);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			assertEquals(1, listenerExecutedCount);
		}

		[Test]
		public function listener_mapped_twice_and_removed_once_doesnt_fire():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listenerWithCounter, CustomEvent);
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listenerWithCounter, CustomEvent);
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listenerWithCounter, CustomEvent);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			assertEquals(0, listenerExecutedCount);
		}

		[Test]
		public function listener_mapped_and_unmapped_without_type_doesnt_fire_in_response_to_typed_or_plain_event():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			assertFalse(listenerExecuted);
		}

		[Test]
		public function listener_mapped_and_unmapped_with_type_doesnt_fire_in_response_to_typed_or_plain_event():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			assertFalse(listenerExecuted);
		}

		[Test]
		public function listener_mapped_with_type_and_unmapped_without_type_fires_in_response_to_typed_event():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			assertTrue(listenerExecuted);
		}

		[Test]
		public function listener_mapped_without_type_and_unmapped_with_type_fires_in_response_to_plain_event():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventMap.unmapListener(eventDispatcher, CustomEvent.STARTED, listener, CustomEvent);
			eventDispatcher.dispatchEvent(new Event(CustomEvent.STARTED));
			assertTrue(listenerExecuted);
		}

		[Test]
		public function unmapListeners_causes_no_handlers_to_fire():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventMap.mapListener(eventDispatcher, Event.COMPLETE, listener);
			eventMap.mapListener(eventDispatcher, Event.CHANGE, listener);
			eventMap.unmapListeners();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertFalse(listenerExecuted);
		}

		[Test]
		public function suspend_causes_no_handlers_to_fire():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventMap.mapListener(eventDispatcher, Event.COMPLETE, listener);
			eventMap.mapListener(eventDispatcher, Event.CHANGE, listener);
			eventMap.suspend();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertFalse(listenerExecuted);
		}

		[Test]
		public function suspend_then_resume_restores_handlers_to_fire():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listenerWithCounter);
			eventMap.mapListener(eventDispatcher, Event.COMPLETE, listenerWithCounter);
			eventMap.mapListener(eventDispatcher, Event.CHANGE, listenerWithCounter);
			eventMap.suspend();
			eventMap.resume();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertEquals(3, listenerExecutedCount);
		}

		[Test]
		public function listeners_added_while_suspended_dont_fire():void
		{
			eventMap.suspend();
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventMap.mapListener(eventDispatcher, Event.COMPLETE, listener);
			eventMap.mapListener(eventDispatcher, Event.CHANGE, listener);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertFalse(listenerExecuted);
		}

		[Test]
		public function listeners_added_while_suspended_fire_after_resume():void
		{
			eventMap.suspend();
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listenerWithCounter);
			eventMap.mapListener(eventDispatcher, Event.COMPLETE, listenerWithCounter);
			eventMap.mapListener(eventDispatcher, Event.CHANGE, listenerWithCounter);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			eventMap.resume();
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertEquals(2, listenerExecutedCount);
		}

		[Test]
		public function listeners_can_be_unmapped_while_suspended():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listenerWithCounter);
			eventMap.mapListener(eventDispatcher, Event.COMPLETE, listenerWithCounter);
			eventMap.mapListener(eventDispatcher, Event.CHANGE, listenerWithCounter);
			eventMap.suspend();
			eventMap.unmapListener(eventDispatcher, Event.CHANGE, listenerWithCounter);
			eventMap.resume();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertEquals(2, listenerExecutedCount);
		}

		[Test]
		public function all_listeners_can_be_unmapped_while_suspended():void
		{
			eventMap.mapListener(eventDispatcher, CustomEvent.STARTED, listener);
			eventMap.mapListener(eventDispatcher, Event.COMPLETE, listener);
			eventMap.mapListener(eventDispatcher, Event.CHANGE, listener);
			eventMap.suspend();
			eventMap.unmapListeners();
			eventMap.resume();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertFalse(listenerExecuted);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function listener(e:Event):void
		{
			listenerExecuted = true;
		}

		protected function resetListenerExecuted():void
		{
			listenerExecuted = false;
		}

		protected function listenerWithCounter(e:Event):void
		{
			listenerExecutedCount++;
		}

		protected function resetListenerExecutedCount():void
		{
			listenerExecutedCount = 0;
		}
	}
}
