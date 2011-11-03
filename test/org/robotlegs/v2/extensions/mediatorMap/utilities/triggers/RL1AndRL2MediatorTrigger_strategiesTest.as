//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.utilities.triggers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import mockolate.runner.MockolateRunner;
	import mockolate.stub;
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.support.DuckTypedRL2Mediator;
	import mx.core.UIComponent;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.strategies.NoWaitStrategy;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.strategies.WaitForCompleteStrategy;
	import flash.events.Event;
	import flash.display.MovieClip;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.strategies.WaitForCreationCompleteStrategy;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTrigger;

	public class RL1AndRL2MediatorTrigger_strategiesTest
	{

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var rl2Mediator:org.robotlegs.v2.extensions.mediatorMap.api.IMediator;

		private const SPRITE:Sprite = new Sprite();
		private const UI_COMPONENT:UIComponent = new UIComponent();
		private const MOVIE_CLIP:MovieClip = new MovieClip();

		private var _callbackRun:Function;

		private var strictInstance:RL1AndRL2MediatorTrigger;

		[Before]
		public function setUp():void
		{
			strictInstance = new RL1AndRL2MediatorTrigger(true);
			UI_COMPONENT.initialized = false;
		}

		[After]
		public function tearDown():void
		{
			strictInstance = null;
		}
		
		[Test]
		public function startup_calls_initialize_immediately_if_no_strategy_added():void
		{
			strictInstance.addStartupStrategy(NoWaitStrategy, new TypeMatcher().allOf(Sprite));
			strictInstance.startup(rl2Mediator, SPRITE);
			assertThat(rl2Mediator, received().method('initialize'));
		}	
		
		[Test]
		public function startup_doesnt_call_initialize_immediately_on_MovieClip_when_matched_to_waitForComplete_strategy():void
		{
			strictInstance.addStartupStrategy(WaitForCompleteStrategy, new TypeMatcher().allOf(MovieClip));
			strictInstance.startup(rl2Mediator, MOVIE_CLIP);
			assertThat(rl2Mediator, received().method('initialize').never());
		}
		
		[Test]
		public function startup_calls_initialize_after_MovieClip_dispatches_complete_when_matched_to_waitForComplete_strategy():void
		{
			strictInstance.addStartupStrategy(WaitForCompleteStrategy, new TypeMatcher().allOf(MovieClip));
			strictInstance.startup(rl2Mediator, MOVIE_CLIP);
			MOVIE_CLIP.dispatchEvent(new Event(Event.COMPLETE));
			assertThat(rl2Mediator, received().method('initialize').once());
		}
		
		[Test]
		public function startup_does_NOT_call_initialize_after_MovieClip_dispatches_complete_if_shutdown_has_run_between():void
		{
			strictInstance.addStartupStrategy(WaitForCompleteStrategy, new TypeMatcher().allOf(MovieClip));
			strictInstance.startup(rl2Mediator, MOVIE_CLIP);
			strictInstance.shutdown(rl2Mediator, MOVIE_CLIP, benignCallback);
			stub(rl2Mediator).getter("destroyed").returns(true);
			MOVIE_CLIP.dispatchEvent(new Event(Event.COMPLETE));
			assertThat(rl2Mediator, received().method('initialize').never());
		}
		
		[Test]
		public function startup_doesnt_call_initialize_immediately_on_unready_UIComponent_when_matched_to_waitForCreationComplete_strategy():void
		{
			strictInstance.addStartupStrategy(WaitForCreationCompleteStrategy, new TypeMatcher().allOf(UIComponent));
			strictInstance.startup(rl2Mediator, UI_COMPONENT);
			assertThat(rl2Mediator, received().method('initialize').never());
		}
		
		[Test]
		public function startup_calls_initialize_after_UIComponent_dispatches_creationComplete_when_matched_to_waitForCreationComplete_strategy():void
		{
			strictInstance.addStartupStrategy(WaitForCreationCompleteStrategy, new TypeMatcher().allOf(UIComponent));
			strictInstance.startup(rl2Mediator, UI_COMPONENT);
			UI_COMPONENT.dispatchEvent(new Event('creationComplete'));
			assertThat(rl2Mediator, received().method('initialize').once());
		}
		
		[Test]
		public function startup_calls_initialize_immediately_if_UIComponent_is_already_initialised():void
		{
			strictInstance.addStartupStrategy(WaitForCreationCompleteStrategy, new TypeMatcher().allOf(UIComponent));
			UI_COMPONENT.initialized = true;
			strictInstance.startup(rl2Mediator, UI_COMPONENT);
			assertThat(rl2Mediator, received().method('initialize').once());
		}
		
		[Test]
		public function startup_does_not_call_initialize_after_creationComplete_if_UIComponent_destroyed_is_true():void
		{
			strictInstance.addStartupStrategy(WaitForCreationCompleteStrategy, new TypeMatcher().allOf(UIComponent));
			strictInstance.startup(rl2Mediator, UI_COMPONENT);
			strictInstance.shutdown(rl2Mediator, UI_COMPONENT, benignCallback);
			stub(rl2Mediator).getter("destroyed").returns(true);
			assertThat(rl2Mediator, received().method('initialize').never());
		}	

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		
		protected function benignCallback(mediator:*, view:DisplayObject):void
		{
			// do nothing
		}
	}
}