//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.stateMachine.impl
{
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.core.async.support.createAsyncHandler;
	import robotlegs.bender.core.async.support.createCallbackHandlerThatErrors;
	import robotlegs.bender.core.async.support.createHandler;

	public class StateMachineTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var stateMachine:StateMachine;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			stateMachine = new StateMachine();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertThat(stateMachine, isA(StateMachine));
		}

		[Test]
		public function should_not_have_state():void
		{
			assertThat(stateMachine.hasState("state"), isFalse());
		}

		[Test]
		public function addState():void
		{
			stateMachine.addState("state", ["step"]);
			assertThat(stateMachine.hasState("state"), isTrue());
		}

		[Test(expects="Error")]
		public function addState_throws_if_state_is_null():void
		{
			stateMachine.addState(null, ["step"]);
		}

		[Test(expects="Error")]
		public function addState_throws_if_state_is_blank():void
		{
			stateMachine.addState("", ["step"]);
		}

		[Test(expects="Error")]
		public function addState_throws_if_step_def_is_null():void
		{
			stateMachine.addState("state", null);
		}

		[Test(expects="Error")]
		public function addState_throws_if_step_def_is_empty():void
		{
			stateMachine.addState("state", []);
		}

		[Test(expects="Error")]
		public function addState_throws_if_any_step_is_null():void
		{
			stateMachine.addState("state", [null]);
		}

		[Test(expects="Error")]
		public function addState_throws_if_any_step_is_blank():void
		{
			stateMachine.addState("state", [""]);
		}

		[Test(expects="Error")]
		public function addState_throws_if_state_already_exists():void
		{
			stateMachine.addState("state", ["step1"]);
			stateMachine.addState("state", ["step2"]);
		}

		[Test(expects="Error")]
		public function addState_throws_if_any_step_already_exists():void
		{
			stateMachine.addState("state1", ["step1"]);
			stateMachine.addState("state2", ["step1"]);
		}

		[Test(expects="Error")]
		public function addState_throws_if_any_step_equals_any_state():void
		{
			stateMachine.addState("state1", ["step1"]);
			stateMachine.addState("state2", ["state1"]);
		}

		[Test(expects="Error")]
		public function addState_throws_if_state_equals_any_step():void
		{
			stateMachine.addState("state1", ["step1"]);
			stateMachine.addState("step1", ["step2"]);
		}

		[Test]
		public function removeState():void
		{
			stateMachine.addState("state", ["step"]);
			stateMachine.removeState("state");
			assertThat(stateMachine.hasState("state"), isFalse());
		}

		[Test]
		public function state_is_set():void
		{
			stateMachine.addState("state", ["step"]);
			stateMachine.state = "state";
			assertThat(stateMachine.state, equalTo("state"));
		}

		[Test(expects="Error")]
		public function setState_throws_when_does_not_have_state():void
		{
			stateMachine.state = "state";
			assertThat(stateMachine.state, equalTo("state"));
		}

		[Test]
		public function addStepHandler():void
		{
			stateMachine.addStateHandler("step", new Function);
		}

		[Test]
		public function step_is_handled():void
		{
			const expected:Array = ["step"];
			const actual:Array = [];
			stateMachine.addState("state", ["step"]);
			stateMachine.addStateHandler("step", createHandler(actual.push, 'step'));
			stateMachine.state = "state";
			assertThat(actual, array(expected));
		}

		[Test]
		public function step_is_not_handled_after_removal():void
		{
			var handled:Boolean;
			stateMachine.addState("state", ["step"]);
			const handler:Function = function():void {
				handled = true;
			};
			stateMachine.addStateHandler("step", handler);
			stateMachine.removeStateHandler("step", handler);
			stateMachine.state = "state";
			assertThat(handled, isFalse());
		}

		[Test]
		public function steps_are_handled_by_sync_handlers():void
		{
			const expected:Array = ["step1", "step2", "step3", "step4"];
			const actual:Array = [];
			stateMachine.addState("state", ["step1", "step2", "step3", "step4"]);
			stateMachine.addStateHandler("step1", createHandler(actual.push, 'step1'));
			stateMachine.addStateHandler("step2", createHandler(actual.push, 'step2'));
			stateMachine.addStateHandler("step3", createHandler(actual.push, 'step3'));
			stateMachine.addStateHandler("step4", createHandler(actual.push, 'step4'));
			stateMachine.state = "state";
			assertThat(actual, array(expected));
		}

		[Test(async)]
		public function steps_are_handled_by_async_handlers():void
		{
			const expected:Array = ["step1", "step2", "step3", "step4"];
			const actual:Array = [];
			stateMachine.addState("state", ["step1", "step2", "step3", "step4"]);
			stateMachine.addStateHandler("step1", createAsyncHandler(actual.push, 'step1'));
			stateMachine.addStateHandler("step2", createAsyncHandler(actual.push, 'step2'));
			stateMachine.addStateHandler("step3", createAsyncHandler(actual.push, 'step3'));
			stateMachine.addStateHandler("step4", createAsyncHandler(actual.push, 'step4'));
			stateMachine.state = "state";
			delayAssertion(function():void {
				assertThat(actual, array(expected));
			}, 200);
		}

		[Test(async)]
		public function steps_are_handled_by_sync_and_async_handlers():void
		{
			const expected:Array = ["step1", "step2", "step3", "step4"];
			const actual:Array = [];
			stateMachine.addState("state", ["step1", "step2", "step3", "step4"]);
			stateMachine.addStateHandler("step1", createAsyncHandler(actual.push, 'step1'));
			stateMachine.addStateHandler("step2", createHandler(actual.push, 'step2'));
			stateMachine.addStateHandler("step3", createAsyncHandler(actual.push, 'step3'));
			stateMachine.addStateHandler("step4", createHandler(actual.push, 'step4'));
			stateMachine.state = "state";
			delayAssertion(function():void {
				assertThat(actual, array(expected));
			}, 200);
		}

		[Test(async)]
		public function step_handlers_are_invoked_in_the_desired_direction():void
		{
			for each (var reverse:Boolean in[false, true])
			{
				const actual:Array = [];
				const expected:Array = ["handler1", "handler2", "handler3", "handler4"];
				reverse && expected.reverse();
				stateMachine = new StateMachine();
				stateMachine.addState("state", ["step1"], reverse);
				stateMachine.addStateHandler("step1", createAsyncHandler(actual.push, 'handler1'));
				stateMachine.addStateHandler("step1", createHandler(actual.push, 'handler2'));
				stateMachine.addStateHandler("step1", createAsyncHandler(actual.push, 'handler3'));
				stateMachine.addStateHandler("step1", createHandler(actual.push, 'handler4'));
				stateMachine.state = "state";
				// gotta close over these otherwise we're just testing the latest twice :)
				(function(reverse:Boolean, actual:Array, expected:Array):void {
					delayAssertion(function():void {
						assertThat("reverse=" + reverse, actual, array(expected));
					}, 200);
				})(reverse, actual, expected);
			}
		}

		[Test]
		public function terminated_step_should_not_reach_further_handlers():void
		{
			const expected:Array = ["step1", "step2", "step3 (with error)"];
			const actual:Array = [];
			stateMachine.addState("state", ["step1", "step2", "step3", "step4"]);
			stateMachine.addStateHandler("step1", createHandler(actual.push, 'step1'));
			stateMachine.addStateHandler("step2", createHandler(actual.push, 'step2'));
			stateMachine.addStateHandler("step3", createCallbackHandlerThatErrors(actual.push, 'step3 (with error)'));
			stateMachine.addStateHandler("step4", createHandler(actual.push, 'step4'));
			stateMachine.state = "state";
			assertThat(actual, array(expected));
		}

		[Test]
		public function callback_is_called():void
		{
			var callCount:int = 0;
			stateMachine.addState("state", ["step1", "step2", "step3", "step4"]);
			stateMachine.setCurrentState("state", function():void {
				callCount++;
			});
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function callback_is_called_once_after_sync_step_handler():void
		{
			var callCount:int = 0;
			stateMachine.addState("state", ["step1", "step2", "step3", "step4"]);
			stateMachine.addStateHandler("step2", createHandler());
			stateMachine.setCurrentState("state", function():void {
				callCount++;
			});
			assertThat(callCount, equalTo(1));
		}

		[Test(async)]
		public function callback_is_called_once_after_async_step_handler():void
		{
			var callCount:int = 0;
			stateMachine.addState("state", ["step1", "step2", "step3", "step4"]);
			stateMachine.addStateHandler("step2", createAsyncHandler());
			stateMachine.setCurrentState("state", function():void {
				callCount++;
			});
			delayAssertion(function():void {
				assertThat(callCount, equalTo(1));
			});
		}

		[Test(async)]
		public function callback_is_called_once_after_sync_and_async_step_handlers_complete():void
		{
			var callCount:int = 0;
			stateMachine.addState("state", ["step1", "step2", "step3", "step4"]);
			stateMachine.addStateHandler("step1", createAsyncHandler());
			stateMachine.addStateHandler("step2", createHandler());
			stateMachine.addStateHandler("step3", createAsyncHandler());
			stateMachine.addStateHandler("step4", createHandler());
			stateMachine.setCurrentState("state", function():void {
				callCount++;
			});
			delayAssertion(function():void {
				assertThat(callCount, equalTo(1));
			}, 100);
		}

		[Test]
		public function callback_receives_step_handler_error():void
		{
			const expected:Object = new Error("error");
			var actual:Object;
			stateMachine.addState("state", ["step"]);
			stateMachine.addStateHandler("step", function(message:Object, callback:Function):void {
				callback(expected);
			});
			stateMachine.addStateHandler("step", new Function());
			stateMachine.setCurrentState("state", function(error:Object):void {
				actual = error;
			});
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function stateChanging_is_true_while_state_is_changing_sync():void
		{
			var actual:Boolean;
			stateMachine.addState("state", ["step"]);
			stateMachine.addStateHandler("step", function():void {
				actual = stateMachine.stateChanging;
			});
			stateMachine.state = "state";
			assertThat(actual, isTrue());
		}

		[Test(async)]
		public function stateChanging_is_true_while_state_is_changing_async():void
		{
			var actual:Boolean;
			stateMachine.addState("state", ["step"]);
			stateMachine.addStateHandler("step", createAsyncHandler());
			stateMachine.addStateHandler("step", function(step:String, callback:Function):void {
				actual = stateMachine.stateChanging;
			});
			stateMachine.addStateHandler("step", createAsyncHandler());
			stateMachine.state = "state";
			delayAssertion(function():void {
				assertThat(actual, isTrue());
			});
		}

		[Test]
		public function stateChanging_is_false_after_sync_state_change():void
		{
			stateMachine.addState("state", ["step"]);
			stateMachine.addStateHandler("step", new Function());
			stateMachine.state = "state";
			assertThat(stateMachine.stateChanging, isFalse());
		}

		[Test(async)]
		public function stateChanging_is_false_after_async_state_change():void
		{
			stateMachine.addState("state", ["step"]);
			stateMachine.addStateHandler("step", new Function());
			stateMachine.addStateHandler("step", createAsyncHandler());
			stateMachine.state = "state";
			delayAssertion(function():void {
				assertThat(stateMachine.stateChanging, isFalse());
			});
		}

		[Test(expects="Error")]
		public function setting_state_throws_if_state_is_changing():void
		{
			stateMachine.addState("state1", ["step1"]);
			stateMachine.addState("state2", ["step2"]);
			stateMachine.addStateHandler("step1", function():void {
				stateMachine.state = "state2";
			});
			stateMachine.state = "state1";
		}

		[Test(expects="Error")]
		public function setting_state_throws_if_state_is_changing_async():void
		{
			stateMachine.addState("state1", ["step1"]);
			stateMachine.addState("state2", ["step2"]);
			stateMachine.addStateHandler("step1", createAsyncHandler());
			stateMachine.state = "state1";
			stateMachine.state = "state2";
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function delayAssertion(closure:Function, delay:Number = 50):void
		{
			Async.delayCall(this, closure, delay);
		}
	}
}
