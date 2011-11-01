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
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.support.DuckTypedRL1Mediator;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;

	// required
	MockolateRunner;

	[RunWith("mockolate.runner.MockolateRunner")]
	public class RL1AndRL2MediatorTriggerTest
	{

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var rl1Mediator:org.robotlegs.core.IMediator;
		
		[Mock]
		public var rl2Mediator:org.robotlegs.v2.extensions.mediatorMap.api.IMediator;

		private var strictInstance:RL1AndRL2MediatorTrigger;
		private var notStrictInstance:RL1AndRL2MediatorTrigger;
		
		private const VIEW:DisplayObject = new Sprite();

		private var _callbackRun:Function;
		
		private const duckMediator:DuckTypedRL1Mediator = new DuckTypedRL1Mediator();

		[Before]
		public function setUp():void
		{
			strictInstance = new RL1AndRL2MediatorTrigger(true);
			notStrictInstance = new RL1AndRL2MediatorTrigger(false);
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
			assertTrue("strictInstance is RL1AndRL2MediatorTrigger", strictInstance is RL1AndRL2MediatorTrigger);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test(expects="Error")]
		public function startup_throws_error_in_strict_mode_when_passed_a_duckTyped_mediator():void
		{
			strictInstance.startup(duckMediator,new Sprite());
		}
		
		[Test(expects="Error")]
		public function shutdown_throws_error_in_strict_mode_when_passed_a_duckTyped_mediator():void
		{
			strictInstance.shutdown(duckMediator,new Sprite(), benignCallback);
		}
		
		[Test]
		public function startup_throws_no_error_in_not_strict_mode_when_passed_a_duckTyped_mediator():void
		{
			notStrictInstance.startup(duckMediator,new Sprite());
		}
		
		[Test]
		public function shutdown_throws_no_error_in_not_strict_mode_when_passed_a_duckTyped_mediator():void
		{
			notStrictInstance.shutdown(duckMediator,new Sprite(), benignCallback);
		}
		
		/* -------------------------

			RL1 Style mediators
			
		---------------------------*/
								
		[Test]
		public function shutdown_calls_callback_in_nonStrictMode_with_RL1Mediator():void
		{
			notStrictInstance.shutdown(rl1Mediator, VIEW, expectantCallbackForRL1Mediator);
			assertEquals(expectantCallbackForRL1Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_callback_in_strictMode_with_RL1Mediator():void
		{
			strictInstance.shutdown(rl1Mediator, VIEW, expectantCallbackForRL1Mediator);
			assertEquals(expectantCallbackForRL1Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_preRemove_on_RL1Mediator_in_not_strict_mode():void
		{
			notStrictInstance.shutdown(rl1Mediator, VIEW, benignCallback);
			assertThat(rl1Mediator, received().method('preRemove'));
		}

		[Test]
		public function shutdown_calls_preRemove_on_RL1Mediator_in_strict_mode():void
		{
			strictInstance.shutdown(rl1Mediator, VIEW, benignCallback);
			assertThat(rl1Mediator, received().method('preRemove'));
		}

		[Test]
		public function startup_calls_preRegister_on_RL1Mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(rl1Mediator, VIEW);
			assertThat(rl1Mediator, received().method('preRegister'));
		}

		[Test]
		public function startup_calls_preRegister_on_RL1Mediator_in_strict_mode():void
		{
			strictInstance.startup(rl1Mediator, VIEW);
			assertThat(rl1Mediator, received().method('preRegister'));
		}

		[Test]
		public function startup_calls_setViewComponent_on_RL1Mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(rl1Mediator, VIEW);
			assertThat(rl1Mediator, received().method('setViewComponent').args(strictlyEqualTo(VIEW)));
		}

		[Test]
		public function startup_calls_setViewComponent_on_RL1Mediator_in_strict_mode():void
		{
			strictInstance.startup(rl1Mediator, VIEW);
			assertThat(rl1Mediator, received().method('setViewComponent').args(strictlyEqualTo(VIEW)));
		}
		
		/* -------------------------

			RL2 Style mediators
			
		---------------------------*/
		
		[Test]
		public function shutdown_calls_callback_in_nonStrictMode_with_RL2Mediator():void
		{
			notStrictInstance.shutdown(rl2Mediator, VIEW, expectantCallbackForRL2Mediator);
			assertEquals(expectantCallbackForRL2Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_callback_in_strictMode_with_RL2Mediator():void
		{
			strictInstance.shutdown(rl2Mediator, VIEW, expectantCallbackForRL2Mediator);
			assertEquals(expectantCallbackForRL2Mediator, _callbackRun);
		}

		[Test]
		public function shutdown_calls_destroy_on_RL2Mediator_in_not_strict_mode():void
		{
			notStrictInstance.shutdown(rl2Mediator, VIEW, benignCallback);
			assertThat(rl2Mediator, received().method('destroy'));
		}

		[Test]
		public function shutdown_calls_destroy_on_RL2Mediator_in_strict_mode():void
		{
			strictInstance.shutdown(rl2Mediator, VIEW, benignCallback);
			assertThat(rl2Mediator, received().method('destroy'));
		}

		
		[Test]
		public function startup_calls_initialize_on_RL2Mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().method('initialize'));
		}

		[Test]
		public function startup_calls_initialize_on_RL2Mediator_in_strict_mode():void
		{
			strictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().method('initialize'));
		}

		[Test]
		public function startup_calls_setViewComponent_on_RL2Mediator_in_not_strict_mode():void
		{
			notStrictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().method('setViewComponent').args(strictlyEqualTo(VIEW)));
		}

		[Test]
		public function startup_calls_setViewComponent_on_RL2Mediator_in_strict_mode():void
		{
			strictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().method('setViewComponent').args(strictlyEqualTo(VIEW)));
		}

		[Test]
		public function startup_sets_destroyed_to_false_on_RL2Mediator():void
		{
			strictInstance.startup(rl2Mediator, VIEW);
			assertThat(rl2Mediator, received().setter("destroyed").args(equalTo(false)));
		}
		
		[Test]
		public function shutdown_sets_destroyed_to_true_on_RL2Mediator():void
		{
			strictInstance.shutdown(rl2Mediator, VIEW, benignCallback);
			assertThat(rl2Mediator, received().setter("destroyed").args(equalTo(true)));
		}
		
		/* PROTECTED FUNCS */


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
		
		protected function expectantCallbackForRL2Mediator(mediator:*, view:DisplayObject):void
		{
			assertEquals(VIEW, view);
			assertEquals(rl2Mediator, mediator);
			_callbackRun = expectantCallbackForRL2Mediator;
		}
			
	}
}