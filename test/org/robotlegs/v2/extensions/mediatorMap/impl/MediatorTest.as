//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.MediatorWatcher;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.TrackingMediator;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.TrackingMediatorWaitsForGiven;
	import flash.events.Event;
	import org.robotlegs.base.EventMap;
	import flash.events.EventDispatcher;

	public class MediatorTest
	{

		private var instance:Mediator;

		private var mediatorWatcher:MediatorWatcher;

		private var trackingMediator:TrackingMediator;

		[Before]
		public function setUp():void
		{
			instance = new Mediator();
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
		public function preRegister_runs_onRegister_immediately_for_item_without_wait_event():void
		{
			trackingMediator.setViewComponent(new Sprite());
			trackingMediator.preRegister();
			var expectedNotifications:Vector.<String> = new <String>[TrackingMediator.ON_REGISTER];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function preRemove_runs_onRemove_immediately():void
		{
			trackingMediator.setViewComponent(new Sprite());
			trackingMediator.preRemove();
			var expectedNotifications:Vector.<String> = new <String>[TrackingMediator.ON_REMOVE];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function preRegister_runs_onRegister_after_required_event():void
		{
			var trackingMediatorWaiting:TrackingMediatorWaitsForGiven;
			trackingMediatorWaiting = new TrackingMediatorWaitsForGiven(mediatorWatcher, Event.COMPLETE, Event);
			
			var view:Sprite = new Sprite();
			
			trackingMediatorWaiting.eventMap = new EventMap(new EventDispatcher());
			trackingMediatorWaiting.setViewComponent(view);
			trackingMediatorWaiting.preRegister();
			
			view.dispatchEvent(new Event(Event.COMPLETE));
						
			var expectedNotifications:Vector.<String> = new <String>[TrackingMediatorWaitsForGiven.ON_REGISTER];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function preRegister_does_NOT_run_onRegister_before_required_event():void
		{
			var trackingMediatorWaiting:TrackingMediatorWaitsForGiven;
			trackingMediatorWaiting = new TrackingMediatorWaitsForGiven(mediatorWatcher, Event.COMPLETE, Event);
			
			var view:Sprite = new Sprite();

			trackingMediatorWaiting.eventMap = new EventMap(new EventDispatcher());
			trackingMediatorWaiting.setViewComponent(view);
			trackingMediatorWaiting.preRegister();
									
			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		// mediator pauses event map on view removed and resumes again on view added
		// sugar methods for add / remove view listener and context listener
		// don't run the onRegister if 'removed'
	}
}