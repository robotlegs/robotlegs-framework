//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.support.RL2Mediator;
	import org.swiftsuspenders.Injector;
	import flash.events.EventDispatcher;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1MediatorTrigger;
	import robotlegs.bender.extensions.eventMap.impl.EventMap;
	import robotlegs.bender.extensions.eventMap.api.IEventMap;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.extensions.viewMap.impl.ViewMap;

	public class MediatorMapRemovalAndReparentingTests
	{

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		/* Public Properties                                                         */

		[Mock]
		public var trigger:RL1MediatorTrigger;

		private var _callbackRun:Function;

		private const container1:Sprite = new Sprite();

		private var injector:Injector;

		private var instance:MediatorMap;

		private var view:DisplayObject;

		[Before]
		public function setUp():void
		{
			instance = new MediatorMap();
			view = new Sprite();
			_callbackRun = null;

			const eventDispatcher:IEventDispatcher = new EventDispatcher();

			injector = new Injector();

			const viewMap:ViewMap = new ViewMap();
			viewMap.injector = injector;

			injector.map(IEventMap).toValue(new EventMap(eventDispatcher));
			injector.map(IEventDispatcher).toValue(eventDispatcher);

			instance = new MediatorMap();
			instance.injector = injector;
			instance.viewMap = viewMap;

			instance.loadTrigger(trigger);

			instance.map(Sprite).toMediator(RL2Mediator);
		}

		[After]
		public function tearDown():void
		{
			injector = null;
			instance = null;
			view = null;
		}

		[Test]
		public function handleViewRemoved_shutdown_is_not_run_immediately_if_view_parent_not_null():void
		{
			container1.addChild(view);
			instance.processView(view, null);
			instance.releaseView(view);
			assertThat(trigger, received().method('shutdown').never());
		}

		[Test]
		public function handleViewRemoved_shutdown_is_run_after_EnterFrame():void
		{
			container1.addChild(view);
			instance.processView(view, null);
			instance.releaseView(view);
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			assertThat(trigger, received().method('shutdown'));
		}

		[Test]
		public function handleViewRemoved_shutdown_is_run_immediately_if_view_parent_is_null():void
		{
			instance.processView(view, null);
			instance.releaseView(view);
			assertThat(trigger, received().method('shutdown'));
		}

		[Test]
		public function handleViewRemoved_shutdown_only_runs_once_for_multiple_ENTER_FRAMEs():void
		{
			container1.addChild(view);
			instance.processView(view, null);
			instance.releaseView(view);
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			assertThat(trigger, received().method('shutdown').once());
		}

		[Test]
		public function shutdown_doesnt_run_if_handleViewAdded_runs_with_same_view_before_enterFrame():void
		{
			container1.addChild(view);
			instance.processView(view, null);
			instance.releaseView(view);
			instance.processView(view, null);
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			assertThat(trigger, received().method('shutdown').never());
		}

		[Test]
		public function startup_does_run_if_handleViewAdded_runs_with_a_view_after_it_has_been_removed_and_EnterFrame_ran():void
		{
			container1.addChild(view);
			instance.processView(view, null);
			instance.releaseView(view);
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			instance.processView(view, null);
			assertThat(trigger, received().method('startup').twice());
		}

		[Test]
		public function startup_doesnt_run_again_if_handleViewAdded_runs_with_a_view_marked_for_removal():void
		{
			container1.addChild(view);
			instance.processView(view, null);
			instance.releaseView(view);
			instance.processView(view, null);
			assertThat(trigger, received().method('startup').once());
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
	}
}