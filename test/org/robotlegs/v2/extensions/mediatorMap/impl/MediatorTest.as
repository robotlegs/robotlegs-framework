//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import mockolate.runner.MockolateRunner;
	import mockolate.stub;
	import mx.core.UIComponent;
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.MediatorWatcher;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.TrackingMediator;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.TrackingMediatorWaitsForGiven;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;
	import flash.display.DisplayObject;
	
	// required
	MockolateRunner;

	[RunWith("mockolate.runner.MockolateRunner")]
	public class MediatorTest
	{
		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var eventMap:IEventMap;

		private var instance:Mediator;

		private var mediatorWatcher:MediatorWatcher;

		private var trackingMediator:TrackingMediator;
		
		[Before]
		public function setUp():void
		{
			instance = new Mediator();
			instance.eventMap = eventMap;
			mediatorWatcher = new MediatorWatcher();
			trackingMediator = new TrackingMediator(mediatorWatcher);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			mediatorWatcher = null;
			trackingMediator = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is Mediator", instance is Mediator);
		}

		[Test]
		public function getViewComponent_matches_setViewComponent():void
		{
			const view:Sprite = new Sprite();
			instance.setViewComponent(view);
			assertEquals(view, instance.getViewComponent());
		}

		[Test]
		public function implements_IMediator():void
		{
			assertTrue(instance is IMediator)
		}

		[Test]
		public function destroyed_defaults_to_false():void
		{
			assertFalse(instance.destroyed);
		}
		
		[Test]
		public function get_set_destroyed_to_true():void 
		{
			instance.destroyed =  true;
			assertTrue(instance.destroyed);
		}

		[Test]
		public function get_set_destroyed_to_false():void 
		{
			instance.destroyed = true;
			instance.destroyed =  false;
			assertFalse(instance.destroyed);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function mediator_suspends_eventMap_on_view_removed():void
		{
			const view:DisplayObject = new Sprite();
			
			instance.setViewComponent(view);
			
			view.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
			assertThat(eventMap, received().method('suspend').once());
		}
		
		[Test]
		public function mediator_resumes_eventMap_on_view_removed():void
		{
			const view:DisplayObject = new Sprite();
			
			instance.setViewComponent(view);
			
			view.dispatchEvent(new Event(Event.REMOVED_FROM_STAGE));
			view.dispatchEvent(new Event(Event.ADDED_TO_STAGE));
			assertThat(eventMap, received().method('resume').once());
		}
	}
}