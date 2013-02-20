//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.framework.api.LifecycleEvent;
	import robotlegs.bender.framework.api.LifecycleState;
	import robotlegs.bender.framework.impl.Lifecycle;
	import robotlegs.bender.framework.impl.LifecycleTransition;

	public class LifecycleTransitionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var lifecycle:Lifecycle;

		private var transition:LifecycleTransition;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			const target:Object = {};
			lifecycle = new Lifecycle(target);
			transition = new LifecycleTransition("test", lifecycle);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(expects="Error")]
		public function invalid_transition_throws_error():void
		{
			transition.fromStates("impossible").enter();
		}

		[Test]
		public function invalid_transition_does_not_throw_when_errorListener_is_attached():void
		{
			lifecycle.addEventListener(LifecycleEvent.ERROR, function(event:LifecycleEvent):void {
			});
			transition.fromStates("impossible").enter();
		}

		[Test]
		public function finalState_is_set():void
		{
			transition.toStates(LifecycleState.INITIALIZING, LifecycleState.ACTIVE).enter();
			assertThat(lifecycle.state, equalTo(LifecycleState.ACTIVE));
		}

		[Test]
		public function transitionState_is_set():void
		{
			transition.toStates(LifecycleState.INITIALIZING, LifecycleState.ACTIVE)
				.addBeforeHandler(function(message:Object, callback:Function):void {
					setTimeout(callback, 1);
				})
				.enter();
			assertThat(lifecycle.state, equalTo(LifecycleState.INITIALIZING));
		}

		[Test]
		public function lifecycle_events_are_dispatched():void
		{
			const actual:Array = [];
			const expected:Array = [
				LifecycleEvent.PRE_INITIALIZE,
				LifecycleEvent.INITIALIZE,
				LifecycleEvent.POST_INITIALIZE];
			transition.withEvents(expected[0], expected[1], expected[2]);
			for each (var type:String in expected)
			{
				lifecycle.addEventListener(type, function(event:Event):void {
					actual.push(event.type);
				});
			}
			transition.enter();
			assertThat(actual, array(expected));
		}

		[Test]
		public function listeners_are_reversed():void
		{
			const actual:Array = [];
			const expected:Array = [3, 2, 1];
			transition.withEvents("preEvent", "event", "postEvent").inReverse();
			lifecycle.addEventListener("event", function(event:Event):void {
				actual.push(1);
			});
			lifecycle.addEventListener("event", function(event:Event):void {
				actual.push(2);
			});
			lifecycle.addEventListener("event", function(event:Event):void {
				actual.push(3);
			});
			transition.enter();
			assertThat(actual, array(expected));
		}

		[Test]
		public function callback_is_called():void
		{
			var callCount:int = 0;
			transition.enter(function():void {
				callCount++;
			});
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function beforeHandlers_are_run():void
		{
			const expected:Array = ["a", "b", "c"];
			const actual:Array = [];
			transition.addBeforeHandler(function():void {
				actual.push("a");
			});
			transition.addBeforeHandler(function():void {
				actual.push("b");
			});
			transition.addBeforeHandler(function():void {
				actual.push("c");
			});
			transition.enter();
			assertThat(actual, array(expected));
		}

		[Test]
		public function beforeHandlers_are_run_in_reverse():void
		{
			const expected:Array = ["c", "b", "a"];
			const actual:Array = [];
			transition.inReverse();
			transition.addBeforeHandler(function():void {
				actual.push("a");
			});
			transition.addBeforeHandler(function():void {
				actual.push("b");
			});
			transition.addBeforeHandler(function():void {
				actual.push("c");
			});
			transition.enter();
			assertThat(actual, array(expected));
		}

		[Test(expects="Error")]
		public function beforeHandler_error_throws():void
		{
			transition.addBeforeHandler(function(message:String, callback:Function):void {
				callback("some error message");
			}).enter();
		}

		[Test]
		public function beforeHandler_does_not_throw_when_errorListener_is_attached():void
		{
			const expected:Error = new Error("There was a problem");
			var actual:Error = null;
			lifecycle.addEventListener(LifecycleEvent.ERROR, function(event:LifecycleEvent):void {
			});
			transition.addBeforeHandler(function(message:String, callback:Function):void {
				callback(expected);
			}).enter(function(error:Error):void {
				actual = error;
			});
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function invalidTransition_is_passed_to_callback_when_errorListener_is_attached():void
		{
			var actual:Object = null;
			lifecycle.addEventListener(LifecycleEvent.ERROR, function(event:LifecycleEvent):void {
			});
			transition.fromStates("impossible").enter(function(error:Object):void {
				actual = error;
			});
			assertThat(actual, instanceOf(Error));
		}

		[Test]
		public function beforeHandlerError_reverts_state():void
		{
			const expected:String = lifecycle.state;
			lifecycle.addEventListener(LifecycleEvent.ERROR, function(event:LifecycleEvent):void {
			});
			transition.fromStates(LifecycleState.UNINITIALIZED)
				.toStates("startState", "endState")
				.addBeforeHandler(function(message:String, callback:Function):void {
					callback("There was a problem");
				}).enter();
			assertThat(lifecycle.state, equalTo(expected));
		}

		[Test]
		public function callback_is_called_if_already_transitioned():void
		{
			var callCount:int = 0;
			transition.fromStates(LifecycleState.UNINITIALIZED).toStates("startState", "endState");
			transition.enter();
			transition.enter(function():void {
				callCount++;
			});
			assertThat(callCount, equalTo(1));
		}

		[Test(async)]
		public function callback_added_during_transition_is_called():void
		{
			var callCount:int = 0;
			transition.fromStates(LifecycleState.UNINITIALIZED)
				.toStates("startState", "endState")
				.addBeforeHandler(function(message:Object, callback:Function):void {
					setTimeout(callback, 1);
				});
			transition.enter();
			transition.enter(function():void {
				callCount++;
			});
			Async.delayCall(this, function():void {
				assertThat(callCount, equalTo(1));
			}, 50);
		}
	}
}
