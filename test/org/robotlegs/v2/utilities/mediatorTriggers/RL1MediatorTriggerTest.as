//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.utilities.mediatorTriggers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import mockolate.runner.MockolateRunner;
	import org.flexunit.asserts.*;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	// required
	MockolateRunner;

	[RunWith("mockolate.runner.MockolateRunner")]
	public class RL1MediatorTriggerTest
	{

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var not_a_RL1_mediator:org.robotlegs.v2.extensions.mediatorMap.api.IMediator;

		[Mock]
		public var not_a_mediator:Object;

		[Mock]
		public var rl1Mediator:org.robotlegs.core.IMediator;

		private const VIEW:DisplayObject = new Sprite();

		private var _callbackRun:Function;

		private var notStrictInstance:RL1MediatorTrigger;

		private var strictInstance:RL1MediatorTrigger;

		[Before]
		public function setUp():void
		{
			strictInstance = new RL1MediatorTrigger(true);
			notStrictInstance = new RL1MediatorTrigger(false);
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
			assertTrue("strictInstance is RL1MediatorTrigger", strictInstance is RL1MediatorTrigger);
		}

		[Test]
		public function shutdown_calls_callback_in_nonStrictMode_with_mediator():void
		{
			notStrictInstance.shutdown(rl1Mediator, VIEW, expectantCallbackForRL1Mediator);
			assertEquals(expectantCallbackForRL1Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_callback_in_strictMode_with_mediator():void
		{
			strictInstance.shutdown(rl1Mediator, VIEW, expectantCallbackForRL1Mediator);
			assertEquals(expectantCallbackForRL1Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_preRemove_on_mediator_in_not_strict_mode():void
		{
			notStrictInstance.shutdown(rl1Mediator, VIEW, benignCallback);
			assertThat(rl1Mediator, received().method('preRemove'));
		}

		[Test]
		public function shutdown_calls_preRemove_on_mediator_in_strict_mode():void
		{
			strictInstance.shutdown(rl1Mediator, VIEW, benignCallback);
			assertThat(rl1Mediator, received().method('preRemove'));
		}

		[Test]
		public function shutdown_calls_preRemove_on_notARL1mediator_in_strict_mode():void
		{
			strictInstance.shutdown(not_a_RL1_mediator, VIEW, benignCallback);
			assertThat(not_a_RL1_mediator, received().method('preRemove'));
		}

		[Test]
		public function shutdown_does_not_call_preRemove_on_notARL1mediator_in_not_strict_mode():void
		{
			notStrictInstance.shutdown(not_a_RL1_mediator, VIEW, benignCallback);
			assertThat(not_a_RL1_mediator, received().method('preRemove').never());
		}

		[Test]
		public function shutdown_doesnt_error_in_not_strict_mode_with_not_a_mediator():void
		{
			notStrictInstance.shutdown(not_a_mediator, VIEW, benignCallback);
		}

		[Test]
		public function shutdown_still_calls_callback_in_nonStrictMode_with_not_a_RL1_mediator():void
		{
			notStrictInstance.shutdown(not_a_RL1_mediator, VIEW, callbackFor_not_a_RL1_mediator);
			assertEquals(callbackFor_not_a_RL1_mediator, _callbackRun);
		}

		[Test(expects="ReferenceError")]
		public function shutdown_throws_error_in_strict_mode_with_not_a_mediator():void
		{
			strictInstance.shutdown(not_a_mediator, VIEW, benignCallback);
		}

		[Test]
		public function startup_calls_preRegister_on_mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(rl1Mediator, VIEW);
			assertThat(rl1Mediator, received().method('preRegister'));
		}

		[Test]
		public function startup_calls_preRegister_on_mediator_in_strict_mode():void
		{
			strictInstance.startup(rl1Mediator, VIEW);
			assertThat(rl1Mediator, received().method('preRegister'));
		}

		[Test]
		public function startup_calls_setViewComponent_on_mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(rl1Mediator, VIEW);
			assertThat(rl1Mediator, received().method('setViewComponent').args(strictlyEqualTo(VIEW)));
		}

		[Test]
		public function startup_calls_setViewComponent_on_mediator_in_strict_mode():void
		{
			strictInstance.startup(rl1Mediator, VIEW);
			assertThat(rl1Mediator, received().method('setViewComponent').args(strictlyEqualTo(VIEW)));
		}

		[Test]
		public function startup_does_NOT_call_preRegister_on_notARL1mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(not_a_RL1_mediator, VIEW);
			assertThat(not_a_RL1_mediator, received().method('preRegister').never());
		}

		[Test]
		public function startup_does_NOT_call_setViewComponent_on_notARL1mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(not_a_RL1_mediator, VIEW);
			assertThat(not_a_RL1_mediator, received().method('setViewComponent').never());
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
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		protected function benignCallback(mediator:*, view:DisplayObject):void
		{
			// do nothing
		}

		protected function expectantCallbackForRL1Mediator(mediator:*, view:DisplayObject):void
		{
			assertEquals(VIEW, view);
			assertEquals(rl1Mediator, mediator);
			_callbackRun = expectantCallbackForRL1Mediator;
		}

		protected function callbackFor_not_a_RL1_mediator(mediator:*, view:DisplayObject):void
		{
			assertEquals(VIEW, view);
			assertEquals(not_a_RL1_mediator, mediator);
			_callbackRun = callbackFor_not_a_RL1_mediator;
		}
	}
}
