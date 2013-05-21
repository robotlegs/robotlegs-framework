//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.utils.setTimeout;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.framework.api.LifecycleEvent;
	import robotlegs.bender.framework.api.LifecycleState;

	public class LifecycleTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var target:Object;

		private var lifecycle:Lifecycle;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			target = {};
			lifecycle = new Lifecycle(target);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function lifecycle_starts_uninitialized():void
		{
			assertThat(lifecycle.state, equalTo(LifecycleState.UNINITIALIZED));
			assertThat(lifecycle.uninitialized, isTrue());
		}

		[Test]
		public function target_is_correct():void
		{
			assertThat(lifecycle.target, equalTo(target));
		}

		// ----- Basic valid transitions

		[Test]
		public function initialize_turns_state_active():void
		{
			lifecycle.initialize();
			assertThat(lifecycle.state, equalTo(LifecycleState.ACTIVE));
			assertThat(lifecycle.active, isTrue());
		}

		[Test]
		public function suspend_turns_state_suspended():void
		{
			lifecycle.initialize();
			lifecycle.suspend();
			assertThat(lifecycle.state, equalTo(LifecycleState.SUSPENDED));
			assertThat(lifecycle.suspended, isTrue());
		}

		[Test]
		public function resume_turns_state_active():void
		{
			lifecycle.initialize();
			lifecycle.suspend();
			lifecycle.resume();
			assertThat(lifecycle.state, equalTo(LifecycleState.ACTIVE));
			assertThat(lifecycle.active, isTrue());
		}

		[Test]
		public function destroy_turns_state_destroyed():void
		{
			lifecycle.initialize();
			lifecycle.destroy();
			assertThat(lifecycle.state, equalTo(LifecycleState.DESTROYED));
			assertThat(lifecycle.destroyed, isTrue());
		}

		[Test]
		public function typical_transition_chain_does_not_throw_errors():void
		{
			const methods:Array = [
				lifecycle.initialize,
				lifecycle.suspend,
				lifecycle.resume,
				lifecycle.suspend,
				lifecycle.resume,
				lifecycle.destroy];
			assertThat(methodErrorCount(methods), equalTo(0));
		}

		// ----- Invalid transitions

		[Test]
		public function from_uninitialized___suspend_resume_and_destroy_throw_errors():void
		{
			const methods:Array = [
				lifecycle.suspend,
				lifecycle.resume,
				lifecycle.destroy];
			assertThat(methodErrorCount(methods), equalTo(3));
		}

		[Test(expects="Error")]
		public function from_suspended___initialize_throws_error():void
		{
			lifecycle.initialize();
			lifecycle.suspend();
			lifecycle.initialize();
		}

		[Test]
		public function from_destroyed___initialize_suspend_and_resume_throw_errors():void
		{
			const methods:Array = [
				lifecycle.initialize,
				lifecycle.suspend,
				lifecycle.resume];
			lifecycle.initialize();
			lifecycle.destroy();
			assertThat(methodErrorCount(methods), equalTo(3));
		}

		// ----- Events

		[Test]
		public function events_are_dispatched():void
		{
			const actual:Array = [];
			const expected:Array = [
				LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE,
				LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND,
				LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME,
				LifecycleEvent.PRE_DESTROY, LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY];
			const listener:Function = function(event:LifecycleEvent):void {
				actual.push(event.type);
			};
			for each (var type:String in expected)
			{
				lifecycle.addEventListener(type, listener);
			}
			lifecycle.initialize();
			lifecycle.suspend();
			lifecycle.resume();
			lifecycle.destroy();
			assertThat(actual, array(expected));
		}

		// ----- Shorthand transition handlers

		[Test(expects="robotlegs.bender.framework.api.LifecycleError")]
		public function whenHandler_with_more_than_1_argument_throws():void
		{
			lifecycle.whenInitializing(function(phase:String, callback:Function):void {
			});
		}

		[Test(expects="robotlegs.bender.framework.api.LifecycleError")]
		public function afterHandler_with_more_than_1_argument_throws():void
		{
			lifecycle.afterInitializing(function(phase:String, callback:Function):void {
			});
		}

		[Test]
		public function when_and_afterHandlers_with_single_arguments_receive_event_types():void
		{
			const expected:Array = [
				LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE,
				LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND,
				LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME,
				LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY];
			const actual:Array = [];
			const handler:Function = function(type:String):void {
				actual.push(type);
			};
			lifecycle
				.whenInitializing(handler).afterInitializing(handler)
				.whenSuspending(handler).afterSuspending(handler)
				.whenResuming(handler).afterResuming(handler)
				.whenDestroying(handler).afterDestroying(handler);
			lifecycle.initialize();
			lifecycle.suspend();
			lifecycle.resume();
			lifecycle.destroy();
			assertThat(actual, array(expected));
		}

		[Test]
		public function when_and_afterHandlers_with_no_arguments_are_called():void
		{
			var callCount:int = 0;
			const handler:Function = function():void {
				callCount++;
			};
			lifecycle
				.whenInitializing(handler).afterInitializing(handler)
				.whenSuspending(handler).afterSuspending(handler)
				.whenResuming(handler).afterResuming(handler)
				.whenDestroying(handler).afterDestroying(handler);
			lifecycle.initialize();
			lifecycle.suspend();
			lifecycle.resume();
			lifecycle.destroy();
			assertThat(callCount, equalTo(8));
		}

		[Test]
		public function before_handlers_are_executed():void
		{
			var callCount:int = 0;
			const handler:Function = function():void {
				callCount++;
			};
			lifecycle
				.beforeInitializing(handler)
				.beforeSuspending(handler)
				.beforeResuming(handler)
				.beforeDestroying(handler);
			lifecycle.initialize();
			lifecycle.suspend();
			lifecycle.resume();
			lifecycle.destroy();
			assertThat(callCount, equalTo(4));
		}

		[Test(async)]
		public function async_before_handlers_are_executed():void
		{
			var callCount:int = 0;
			const handler:Function = function(message:Object, callback:Function):void {
				callCount++;
				setTimeout(callback, 1);
			};
			lifecycle
				.beforeInitializing(handler)
				.beforeSuspending(handler)
				.beforeResuming(handler)
				.beforeDestroying(handler);
			lifecycle.initialize(function():void {
				lifecycle.suspend(function():void {
					lifecycle.resume(function():void {
						lifecycle.destroy();
					})
				})
			});
			Async.delayCall(this, function():void {
				assertThat(callCount, equalTo(4));
			}, 200);
		}

		// ----- Suspend and Destroy run backwards

		[Test]
		public function suspend_runs_backwards():void
		{
			const actual:Array = [];
			lifecycle.beforeSuspending(createValuePusher(actual, "before1"));
			lifecycle.beforeSuspending(createValuePusher(actual, "before2"));
			lifecycle.beforeSuspending(createValuePusher(actual, "before3"));
			lifecycle.whenSuspending(createValuePusher(actual, "when1"));
			lifecycle.whenSuspending(createValuePusher(actual, "when2"));
			lifecycle.whenSuspending(createValuePusher(actual, "when3"));
			lifecycle.afterSuspending(createValuePusher(actual, "after1"));
			lifecycle.afterSuspending(createValuePusher(actual, "after2"));
			lifecycle.afterSuspending(createValuePusher(actual, "after3"));
			lifecycle.initialize();
			lifecycle.suspend();
			assertThat(actual, array([
				"before3", "before2", "before1",
				"when3", "when2", "when1",
				"after3", "after2", "after1"]));
		}

		[Test]
		public function destroy_runs_backwards():void
		{
			const actual:Array = [];
			lifecycle.beforeDestroying(createValuePusher(actual, "before1"));
			lifecycle.beforeDestroying(createValuePusher(actual, "before2"));
			lifecycle.beforeDestroying(createValuePusher(actual, "before3"));
			lifecycle.whenDestroying(createValuePusher(actual, "when1"));
			lifecycle.whenDestroying(createValuePusher(actual, "when2"));
			lifecycle.whenDestroying(createValuePusher(actual, "when3"));
			lifecycle.afterDestroying(createValuePusher(actual, "after1"));
			lifecycle.afterDestroying(createValuePusher(actual, "after2"));
			lifecycle.afterDestroying(createValuePusher(actual, "after3"));
			lifecycle.initialize();
			lifecycle.destroy();
			assertThat(actual, array([
				"before3", "before2", "before1",
				"when3", "when2", "when1",
				"after3", "after2", "after1"]));
		}

		// ----- Before handlers callback message

		[Test]
		public function beforeHandler_callbacks_are_passed_correct_message():void
		{
			const expected:Array = [
				LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE,
				LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND,
				LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME,
				LifecycleEvent.PRE_DESTROY, LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY];
			const actual:Array = [];
			lifecycle.beforeInitializing(createMessagePusher(actual));
			lifecycle.whenInitializing(createMessagePusher(actual));
			lifecycle.afterInitializing(createMessagePusher(actual));
			lifecycle.beforeSuspending(createMessagePusher(actual));
			lifecycle.whenSuspending(createMessagePusher(actual));
			lifecycle.afterSuspending(createMessagePusher(actual));
			lifecycle.beforeResuming(createMessagePusher(actual));
			lifecycle.whenResuming(createMessagePusher(actual));
			lifecycle.afterResuming(createMessagePusher(actual));
			lifecycle.beforeDestroying(createMessagePusher(actual));
			lifecycle.whenDestroying(createMessagePusher(actual));
			lifecycle.afterDestroying(createMessagePusher(actual));
			lifecycle.initialize();
			lifecycle.suspend();
			lifecycle.resume();
			lifecycle.destroy();
			assertThat(actual, array(expected));
		}

		// ----- StateChange Event

		[Test]
		public function stateChange_triggers_event():void
		{
			var event:LifecycleEvent = null;
			lifecycle.addEventListener(LifecycleEvent.STATE_CHANGE, function(e:LifecycleEvent):void {
				event = e;
			});
			lifecycle.initialize();
			assertThat(event.type, equalTo(LifecycleEvent.STATE_CHANGE));
		}

		// ----- Adding handlers that will never be called

		[Test(expects="robotlegs.bender.framework.api.LifecycleError")]
		public function adding_beforeInitializing_handler_after_initialization_throws_error():void
		{
			lifecycle.initialize();
			lifecycle.beforeInitializing(nop);
		}

		[Test(expects="robotlegs.bender.framework.api.LifecycleError")]
		public function adding_whenInitializing_handler_after_initialization_throws_error():void
		{
			lifecycle.initialize();
			lifecycle.whenInitializing(nop);
		}

		[Test(async, timeout='200')]
		public function adding_whenInitializing_handler_during_initialization_does_NOT_throw_error():void
		{
			var callCount:int = 0;
			lifecycle.beforeInitializing(function(message:Object, callback:Function):void {
				setTimeout(callback, 100);
			});
			lifecycle.initialize();
			lifecycle.whenInitializing(function():void {
				callCount++;
				assertThat(callCount, equalTo(1));
			});
		}

		[Test(expects="robotlegs.bender.framework.api.LifecycleError")]
		public function adding_afterInitializing_handler_after_initialization_throws_error():void
		{
			lifecycle.initialize();
			lifecycle.afterInitializing(nop);
		}

		[Test]
		public function adding_afterInitializing_handler_during_initialization_does_NOT_throw_error():void
		{
			var callCount:int = 0;
			lifecycle.whenInitializing(function():void {
				lifecycle.afterInitializing(function():void {
					callCount++;
				});
			});
			lifecycle.initialize();
			assertThat(callCount, equalTo(1));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function methodErrorCount(methods:Array):int
		{
			var errorCount:int = 0;
			for each (var method:Function in methods)
			{
				try
				{
					method();
				}
				catch (error:Error)
				{
					errorCount++;
				}
			}
			return errorCount;
		}

		private function createValuePusher(array:Array, value:Object):Function
		{
			return function():void {
				array.push(value);
			};
		}

		private function createMessagePusher(array:Array):Function
		{
			return function(message:Object):void {
				array.push(message);
			};
		}

		private function nop():void
		{
		}
	}
}
