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
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import flash.errors.IllegalOperationError;

	public class DuckTypedMediatorTriggerTest
	{

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var notAMediator:Object;

		[Mock]
		public var rl2Mediator:org.robotlegs.v2.extensions.mediatorMap.api.IMediator;

		private const VIEW:DisplayObject = new Sprite();

		private var _callbackRun:Function;

		private var notStrictInstance:DuckTypedMediatorTrigger;

		private var strictInstance:DuckTypedMediatorTrigger;

		[Before]
		public function setUp():void
		{
			strictInstance = new DuckTypedMediatorTrigger(true);
			notStrictInstance = new DuckTypedMediatorTrigger(false);
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
			assertTrue("strictInstance is DuckTypedMediatorTrigger", strictInstance is DuckTypedMediatorTrigger);
		}

		[Test]
		public function shutdown_calls_callback_in_nonStrictMode_with_mediator():void
		{
			notStrictInstance.shutdown(rl2Mediator, VIEW, expectantCallbackForRL2Mediator);
			assertEquals(expectantCallbackForRL2Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_callback_in_nonStrictMode_with_notAMediator():void
		{
			notStrictInstance.shutdown(notAMediator, VIEW, expectantCallbackForNotAMediator);
			assertEquals(expectantCallbackForNotAMediator, _callbackRun);
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
		public function shutdown_doesnt_error_in_not_strict_mode_with_notAMediator():void
		{
			notStrictInstance.shutdown(notAMediator, VIEW, benignCallback);
		}

		[Test(expects="flash.errors.IllegalOperationError")]
		public function shutdown_throws_error_in_strict_mode_with_notAMediator():void
		{
			strictInstance.shutdown(notAMediator, VIEW, benignCallback);
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
		public function startup_doesnt_error_in_not_strict_mode_with_notAMediator():void
		{
			notStrictInstance.startup(notAMediator, VIEW);
		}

		[Test(expects="flash.errors.IllegalOperationError")]
		public function startup_throws_error_in_strict_mode_with_notAMediator():void
		{
			strictInstance.startup(notAMediator, VIEW);
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

		protected function expectantCallbackForNotAMediator(mediator:*, view:DisplayObject):void
		{
			assertEquals(VIEW, view);
			assertEquals(notAMediator, mediator);
			_callbackRun = expectantCallbackForNotAMediator;
		}
	}
}