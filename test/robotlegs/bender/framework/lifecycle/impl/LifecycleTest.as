//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.lifecycle.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.framework.lifecycle.api.LifecycleEvent;
	import robotlegs.bender.framework.lifecycle.api.LifecycleState;

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
			target = new Object();
			lifecycle = new Lifecycle(target);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function lifecycle_starts_uninitialized():void
		{
			assertThat(lifecycle.state, equalTo(LifecycleState.UNINITIALIZED));
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
		}

		[Test]
		public function suspend_turns_state_suspended():void
		{
			lifecycle.initialize();
			lifecycle.suspend();
			assertThat(lifecycle.state, equalTo(LifecycleState.SUSPENDED));
		}

		[Test]
		public function resume_turns_state_active():void
		{
			lifecycle.initialize();
			lifecycle.suspend();
			lifecycle.resume();
			assertThat(lifecycle.state, equalTo(LifecycleState.ACTIVE));
		}

		[Test]
		public function destroy_turns_state_destroyed():void
		{
			lifecycle.initialize();
			lifecycle.destroy();
			assertThat(lifecycle.state, equalTo(LifecycleState.DESTROYED));
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

		[Test(expects="Error")]
		public function whenHandler_with_more_than_1_argument_throws():void
		{
			lifecycle.whenInitializing(function(a:int, b:int):void {
			});
		}

		[Test(expects="Error")]
		public function afterHandler_with_more_than_1_argument_throws():void
		{
			lifecycle.afterInitializing(function(a:int, b:int):void {
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
	}
}
