//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import mockolate.received;
	import mockolate.runner.MockolateRule; 
	import mockolate.runner.MockolateRunner; 
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	import org.robotlegs.v2.extensions.mediatorMap.impl.MediatorMap;
	import org.robotlegs.v2.utilities.mediatorTriggers.RLMediatorTriggerBase;
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;
	import org.robotlegs.v2.utilities.mediatorTriggers.support.RL2Mediator;

	// required
	MockolateRunner;

	[RunWith("mockolate.runner.MockolateRunner")]
	public class MediatorMapRemovalAndReparentingTests 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var instance:MediatorMap;

		private var reflector:Reflector;

		private var _callbackRun:Function;

		private var view:DisplayObject;

		private const container1:Sprite = new Sprite();

		/*============================================================================*/
		/* Public Properties                                                         */
		/*============================================================================*/

		[Mock]
		public var trigger:RLMediatorTriggerBase;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Before]
		public function setUp():void
		{
			instance = new MediatorMap();
			view = new Sprite();
			_callbackRun = null;
			
			injector = new Injector();
			reflector = new DescribeTypeJSONReflector();

			instance = new MediatorMap();
			instance.hooksProcessor = new HooksProcessor();
			instance.guardsProcessor = new GuardsProcessor();
			instance.injector = injector;
			instance.reflector = reflector;
			instance.hooksProcessor = new HooksProcessor();
			instance.guardsProcessor = new GuardsProcessor();
			instance.loadTrigger(trigger);
			
			instance.map(RL2Mediator).toView(Sprite);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			view = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test]
		public function handleViewRemoved_shutdown_is_run_immediately_if_view_parent_is_null():void
		{
			instance.handleViewAdded(view, null);
			instance.handleViewRemoved(view);
			assertThat(trigger, received().method('shutdown'));
		}

		[Test]
		public function handleViewRemoved_shutdown_is_not_run_immediately_if_view_parent_not_null():void
		{
			container1.addChild(view);
			instance.handleViewAdded(view, null);
			instance.handleViewRemoved(view);
			assertThat(trigger, received().method('shutdown').never());
		}

		[Test]
		public function handleViewRemoved_shutdown_is_run_after_EnterFrame():void
		{
			container1.addChild(view);
			instance.handleViewAdded(view, null);
			instance.handleViewRemoved(view);
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			assertThat(trigger, received().method('shutdown'));
		}

		[Test]
		public function handleViewRemoved_shutdown_only_runs_once_for_multiple_ENTER_FRAMEs():void
		{
			container1.addChild(view);
			instance.handleViewAdded(view, null);
			instance.handleViewRemoved(view);
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			assertThat(trigger, received().method('shutdown').once());
		}

		[Test]
		public function shutdown_doesnt_run_if_handleViewAdded_runs_with_same_view_before_enterFrame():void
		{
			container1.addChild(view);
			instance.handleViewAdded(view, null);
			instance.handleViewRemoved(view);
			instance.handleViewAdded(view, null);
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			assertThat(trigger, received().method('shutdown').never());
		}

		[Test]	
		public function startup_doesnt_run_again_if_handleViewAdded_runs_with_a_view_marked_for_removal():void
		{
			container1.addChild(view);
			instance.handleViewAdded(view, null);
			instance.handleViewRemoved(view);
			instance.handleViewAdded(view, null);
			assertThat(trigger, received().method('startup').once());
		}

		[Test]	
		public function startup_does_run_if_handleViewAdded_runs_with_a_view_after_it_has_been_removed_and_EnterFrame_ran():void
		{
			container1.addChild(view);
			instance.handleViewAdded(view, null);
			instance.handleViewRemoved(view);
			view.dispatchEvent(new Event(Event.ENTER_FRAME));
			instance.handleViewAdded(view, null);
			assertThat(trigger, received().method('startup').twice());
		}
	}
}