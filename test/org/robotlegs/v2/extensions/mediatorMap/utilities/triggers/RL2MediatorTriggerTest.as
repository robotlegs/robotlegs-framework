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
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.support.DuckTypedRL2Mediator;

	// required
	MockolateRunner;

	[RunWith("mockolate.runner.MockolateRunner")]
	public class RL2MediatorTriggerTest
	{

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var not_a_RL2_mediator:DuckTypedRL2Mediator;

		[Mock]
		public var not_a_mediator:Object;

		[Mock]
		public var rl2Mediator:org.robotlegs.v2.extensions.mediatorMap.api.IMediator;

		private const VIEW:DisplayObject = new Sprite();

		private var _callbackRun:Function;

		private var notStrictInstance:RL2MediatorTrigger;

		private var strictInstance:RL2MediatorTrigger;

		[Before]
		public function setUp():void
		{
			strictInstance = new RL2MediatorTrigger(true);
			notStrictInstance = new RL2MediatorTrigger(false);
		}

		[After]
		public function tearDown():void
		{
			strictInstance = null;
			notStrictInstance = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("strictInstance is RL2MediatorTrigger", strictInstance is RL2MediatorTrigger);
		}

		[Test]
		public function shutdown_calls_callback_in_nonStrictMode_with_mediator():void
		{
			notStrictInstance.shutdown(rl2Mediator, VIEW, expectantCallbackForRL2Mediator);
			assertEquals(expectantCallbackForRL2Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_callback_in_strictMode_with_mediator():void
		{
			strictInstance.shutdown(rl2Mediator, VIEW, expectantCallbackForRL2Mediator);
			assertEquals(expectantCallbackForRL2Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_destroy_on_mediator_in_not_strict_mode():void
		{
			notStrictInstance.shutdown(rl2Mediator, VIEW, benignCallback);
			assertThat(rl2Mediator, received().method('destroy'));
		}

		[Test]
		public function shutdown_calls_destroy_on_mediator_in_strict_mode():void
		{
			strictInstance.shutdown(rl2Mediator, VIEW, benignCallback);
			assertThat(rl2Mediator, received().method('destroy'));
		}

		[Test]
		public function shutdown_calls_destroy_on_notARL2mediator_in_strict_mode():void
		{
			strictInstance.shutdown(not_a_RL2_mediator, VIEW, benignCallback);
			assertThat(not_a_RL2_mediator, received().method('destroy'));
		}

		[Test]
		public function shutdown_does_not_call_destroy_on_notARL2mediator_in_not_strict_mode():void
		{
			notStrictInstance.shutdown(not_a_RL2_mediator, VIEW, benignCallback);
			assertThat(not_a_RL2_mediator, received().method('destroy').never());
		}

		[Test]
		public function shutdown_doesnt_error_in_not_strict_mode_with_not_a_mediator():void
		{
			notStrictInstance.shutdown(not_a_mediator, VIEW, benignCallback);
		}

		[Test]
		public function shutdown_still_calls_callback_in_nonStrictMode_with_not_a_RL2_mediator():void
		{
			notStrictInstance.shutdown(not_a_RL2_mediator, VIEW, callbackFor_not_a_RL2_mediator);
			assertEquals(callbackFor_not_a_RL2_mediator, _callbackRun);
		}

		[Test(expects="ReferenceError")]
		public function shutdown_throws_error_in_strict_mode_with_not_a_mediator():void
		{
			strictInstance.shutdown(not_a_mediator, VIEW, benignCallback);
		}

		[Test]
		public function startup_calls_initialize_on_mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().method('initialize'));
		}

		[Test]
		public function startup_calls_initialize_on_mediator_in_strict_mode():void
		{
			strictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().method('initialize'));
		}

		[Test]
		public function startup_calls_setViewComponent_on_mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().method('setViewComponent').args(strictlyEqualTo(VIEW)));
		}

		[Test]
		public function startup_calls_setViewComponent_on_mediator_in_strict_mode():void
		{
			strictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().method('setViewComponent').args(strictlyEqualTo(VIEW)));
		}

		[Test]
		public function startup_does_NOT_call_initialize_on_notARL2mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(not_a_RL2_mediator, VIEW);
			assertThat(not_a_RL2_mediator, received().method('initialize').never());
		}

		[Test]
		public function startup_does_NOT_call_setViewComponent_on_notARL2mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(not_a_RL2_mediator, VIEW);
			assertThat(not_a_RL2_mediator, received().method('setViewComponent').never());
		}

		[Test]
		public function startup_doesnt_error_in_not_strict_mode_with_not_a_mediator():void
		{
			notStrictInstance.startup(not_a_mediator, VIEW);
		}

		[Test(expects="ReferenceError")]
		public function startup_throws_error_in_strict_mode_with_not_a_mediator():void
		{
			strictInstance.startup(not_a_mediator, VIEW);
		}
		
		[Test]
		public function startup_sets_destroyed_to_false_on_mediator():void
		{
			strictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().setter("destroyed").args(equalTo(false)));
		}
		
		[Test]
		public function shutdown_sets_destroyed_to_true_on_mediator():void
		{
			strictInstance.shutdown(rl2Mediator, VIEW, benignCallback);
			assertThat(rl2Mediator, received().setter("destroyed").args(equalTo(true)));
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

		protected function expectantCallbackForRL2Mediator(mediator:*, view:DisplayObject):void
		{
			assertEquals(VIEW, view);
			assertEquals(rl2Mediator, mediator);
			_callbackRun = expectantCallbackForRL2Mediator;
		}

		protected function callbackFor_not_a_RL2_mediator(mediator:*, view:DisplayObject):void
		{
			assertEquals(VIEW, view);
			assertEquals(not_a_RL2_mediator, mediator);
			_callbackRun = callbackFor_not_a_RL2_mediator;
		}
	}
}