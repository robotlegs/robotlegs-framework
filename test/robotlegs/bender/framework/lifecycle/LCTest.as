//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.lifecycle
{
	import flash.events.Event;
	import flash.utils.setTimeout;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	public class LCTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var target:Object;

		private var lifecycle:Lifecycle;

		private var state:State;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			target = new Object();
			lifecycle = new Lifecycle(target);
			state = new State("test", lifecycle);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function lifecycle_starts_uninitialized():void
		{
			assertThat(lifecycle.state, equalTo(Lifecycle.UNINITIALIZED));
		}

		[Test]
		public function target_is_correct():void
		{
			assertThat(lifecycle.target, equalTo(target));
		}

		[Test(expects="Error")]
		public function invalid_transition_throws_error():void
		{
			state.fromStates("impossible").enter();
		}

		[Test]
		public function invalid_transition_does_not_throw_when_errorListener_is_attached():void
		{
			lifecycle.addEventListener(LifecycleEvent.ERROR, function(event:LifecycleEvent):void {
			});
			state.fromStates("impossible").enter();
		}

		[Test]
		public function finalState_is_set():void
		{
			state.toStates(Lifecycle.INITIALIZING, Lifecycle.ACTIVE).enter();
			assertThat(lifecycle.state, equalTo(Lifecycle.ACTIVE));
		}

		[Test]
		public function transitionState_is_set():void
		{
			state.toStates(Lifecycle.INITIALIZING, Lifecycle.ACTIVE)
				.withBeforeHandlers(function(message:Object, callback:Function):void {
					setTimeout(callback, 1);
				})
				.enter();
			assertThat(lifecycle.state, equalTo(Lifecycle.INITIALIZING));
		}

		[Test]
		public function lifecycle_events_are_dispatched():void
		{
			const actual:Array = [];
			const expected:Array = [
				LifecycleEvent.PRE_INITIALIZE,
				LifecycleEvent.INITIALIZE,
				LifecycleEvent.POST_INITIALIZE];
			state.withEvents(expected[0], expected[1], expected[2]);
			for each (var type:String in expected)
			{
				lifecycle.addEventListener(type, function(event:Event):void {
					actual.push(event.type);
				});
			}
			state.enter();
			assertThat(actual, array(expected));
		}

		[Test]
		public function listeners_are_reversed():void
		{
			const actual:Array = [];
			const expected:Array = [3, 2, 1];
			state.withEvents("preEvent", "event", "postEvent").inReverse();
			lifecycle.addEventListener("event", function(event:Event):void {
				actual.push(1);
			});
			lifecycle.addEventListener("event", function(event:Event):void {
				actual.push(2);
			});
			lifecycle.addEventListener("event", function(event:Event):void {
				actual.push(3);
			});
			state.enter();
			assertThat(actual, array(expected));
		}

		[Test(expects="Error")]
		public function enter_locks_fromStates():void
		{
			state.enter();
			state.fromStates("state");
		}

		[Test(expects="Error")]
		public function enter_locks_toStates():void
		{
			state.enter();
			state.toStates("changing", "changed");
		}

		[Test(expects="Error")]
		public function enter_locks_events():void
		{
			state.enter();
			state.withEvents("preEvent", "event", "postEvent");
		}

		[Test(expects="Error")]
		public function enter_locks_reverse():void
		{
			state.enter();
			state.inReverse();
		}

		[Test]
		public function callback_is_called():void
		{
			var callCount:int = 0;
			state.enter(function():void {
				callCount++;
			});
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function beforeHandlers_are_run():void
		{
			const expected:Array = ["a", "b", "c"];
			const actual:Array = [];
			state.withBeforeHandlers(function():void {
				actual.push("a");
			}, function():void {
				actual.push("b");
			}, function():void {
				actual.push("c");
			}).enter();
			assertThat(actual, array(expected));
		}

		[Test]
		public function beforeHandlers_are_run_in_reverse():void
		{
			const expected:Array = ["c", "b", "a"];
			const actual:Array = [];
			state.inReverse();
			state.withBeforeHandlers(function():void {
				actual.push("a");
			}, function():void {
				actual.push("b");
			}, function():void {
				actual.push("c");
			}).enter();
			assertThat(actual, array(expected));
		}

		[Test(expects="Error")]
		public function beforeHandler_error_throws():void
		{
			state.withBeforeHandlers(function(message:String, callback:Function):void {
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
			state.withBeforeHandlers(function(message:String, callback:Function):void {
				callback(expected);
			}).enter(function(error:Error):void {
				actual = error;
			});
			// todo: fix this once the message dispatcher is back to normal
			assertThat(actual.message, array(expected));
		}

		[Test]
		public function invalidTransition_is_passed_to_callback_when_errorListener_is_attached():void
		{
			var actual:Object = null;
			lifecycle.addEventListener(LifecycleEvent.ERROR, function(event:LifecycleEvent):void {
			});
			state.fromStates("impossible").enter(function(error:Object):void {
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
			state.fromStates(Lifecycle.UNINITIALIZED)
				.toStates("startState", "endState")
				.withBeforeHandlers(function(message:String, callback:Function):void {
					callback("There was a problem");
				}).enter();
			assertThat(lifecycle.state, equalTo(expected));
		}

		[Test]
		public function callback_is_called_if_already_transitioned():void
		{
			var callCount:int = 0;
			state.fromStates(Lifecycle.UNINITIALIZED).toStates("startState", "endState");
			state.enter();
			state.enter(function():void {
				callCount++;
			});
			assertThat(callCount, equalTo(1));
		}

		[Test(async)]
		public function callback_added_during_transition_is_called():void
		{
			var callCount:int = 0;
			state.fromStates(Lifecycle.UNINITIALIZED)
				.toStates("startState", "endState")
				.withBeforeHandlers(function(message:Object, callback:Function):void {
					setTimeout(callback, 1);
				});
			state.enter();
			state.enter(function():void {
				callCount++;
			});
			Async.delayCall(this, function():void {
				assertThat(callCount, equalTo(1));
			}, 10);
		}
	}
}

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import robotlegs.bender.core.async.safelyCallBack;
import robotlegs.bender.core.messaging.MessageDispatcher;

class Lifecycle extends EventDispatcher
{

	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/

	public static const UNINITIALIZED:String = "uninitialized";

	public static const INITIALIZING:String = "initializing";

	public static const ACTIVE:String = "active";

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _state:String = UNINITIALIZED;

	public function get state():String
	{
		return _state;
	}

	private var _target:Object;

	public function get target():Object
	{
		return _target;
	}

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private const _reversedEventTypes:Dictionary = new Dictionary();

	private var _reversePriority:int;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function Lifecycle(target:Object)
	{
		_target = target;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	override public function addEventListener(type:String, listener:Function,
		useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
	{
		priority = modPriority(type, priority);
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	/*============================================================================*/
	/* Internal Functions                                                         */
	/*============================================================================*/

	internal function setCurrentState(state:String):void
	{
		if (_state == state)
			return;
		_state = state;

	}

	internal function addReversedEventTypes(... types):void
	{
		for each (var type:String in types)
			_reversedEventTypes[type] = true;
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function modPriority(type:String, priority:int):int
	{
		return (priority == 0 && _reversedEventTypes[type])
			? _reversePriority++
			: priority;
	}
}

class State
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private const _fromStates:Vector.<String> = new Vector.<String>;

	private const _dispatcher:MessageDispatcher = new MessageDispatcher();

	private const _callbacks:Array = [];

	private var _name:String;

	private var _lifecycle:Lifecycle;

	private var _transitionState:String;

	private var _finalState:String;

	private var _preTransitionEvent:String;

	private var _transitionEvent:String;

	private var _postTransitionEvent:String;

	private var _reverse:Boolean;

	private var _locked:Boolean;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function State(name:String, lifecycle:Lifecycle)
	{
		_name = name;
		_lifecycle = lifecycle;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function fromStates(... states):State
	{
		validateLock();
		for each (var state:String in states)
			_fromStates.push(state);
		return this;
	}

	public function toStates(transitionState:String, finalState:String):State
	{
		validateLock();
		_transitionState = transitionState;
		_finalState = finalState;
		return this;
	}

	public function withEvents(preTransitionEvent:String, transitionEvent:String, postTransitionEvent:String):State
	{
		validateLock();
		_preTransitionEvent = preTransitionEvent;
		_transitionEvent = transitionEvent;
		_postTransitionEvent = postTransitionEvent;
		_reverse && _lifecycle.addReversedEventTypes(preTransitionEvent, transitionEvent, postTransitionEvent);
		return this;
	}

	public function inReverse():State
	{
		validateLock();
		_reverse = true;
		_lifecycle.addReversedEventTypes(_preTransitionEvent, _transitionEvent, _postTransitionEvent);
		return this;
	}

	public function withBeforeHandlers(... handlers):State
	{
		for each (var handler:Function in handlers)
			_dispatcher.addMessageHandler(_name, handler);
		return this;
	}

	public function enter(callback:Function = null):void
	{
		// no more configuration beyond this point
		_locked = true;

		// immediately call back if we have already transitioned, and exit
		if (_lifecycle.state == _finalState)
		{
			callback && safelyCallBack(callback, null, _name);
			return;
		}

		// queue this callback if we are mid transition, and exit
		if (_lifecycle.state == _transitionState)
		{
			callback && _callbacks.push(callback);
			return;
		}

		// report invalid transition, and exit
		if (invalidTransition())
		{
			reportError("Invalid transition", [callback]);
			return;
		}

		// store the initial lifecycle state in case we need to roll back
		const initialState:String = _lifecycle.state;

		// queue the first callback
		callback && _callbacks.push(callback);

		// put lifecycle into transition state
		setState(_transitionState);

		// run before handlers
		_dispatcher.dispatchMessage(_name, function(error:Object):void {

			// revert state and report error
			if (error)
			{
				setState(initialState);
				reportError(error, _callbacks);
				return;
			}

			// dispatch pre transition and transition events
			dispatch(_preTransitionEvent);
			dispatch(_transitionEvent);

			// put lifecycle into final state
			setState(_finalState);

			// dispatch post transition event
			dispatch(_postTransitionEvent);

			// process callback queue
			for each (var callback:Function in _callbacks)
				safelyCallBack(callback, null, _name);
			_callbacks.length = 0;

		}, _reverse ? MessageDispatcher.REVERSE : 0); // todo: remove this FLAG nonsense
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function validateLock():void
	{
		_locked && reportError("State is locked");
	}

	private function invalidTransition():Boolean
	{
		return _fromStates.length > 0
			&& _fromStates.indexOf(_lifecycle.state) == -1;
	}

	private function setState(state:String):void
	{
		state && _lifecycle.setCurrentState(state);
	}

	private function dispatch(type:String):void
	{
		if (type && _lifecycle.hasEventListener(type))
			_lifecycle.dispatchEvent(new LifecycleEvent(type));
	}

	private function reportError(message:Object, callbacks:Array = null):void
	{
		// turn message into Error
		const error:Error = message is Error
			? message as Error
			: new Error(message);

		// dispatch error event if a listener exists, or throw
		if (_lifecycle.hasEventListener(LifecycleEvent.ERROR))
		{
			const event:LifecycleEvent = new LifecycleEvent(LifecycleEvent.ERROR);
			event.error = error;
			_lifecycle.dispatchEvent(event);
			// process callback queue
			if (callbacks)
			{
				for each (var callback:Function in callbacks)
					callback && safelyCallBack(callback, error, _name);
				callbacks.length = 0;
			}
		}
		else
		{
			// explode!
			throw(error);
		}
	}
}

class LifecycleEvent extends Event
{

	/*============================================================================*/
	/* Public Static Properties                                                   */
	/*============================================================================*/

	public static const PRE_INITIALIZE:String = "preInitialize";

	public static const INITIALIZE:String = "initialize";

	public static const POST_INITIALIZE:String = "postInitialize";

	public static const ERROR:String = "error";

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var error:Error;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	function LifecycleEvent(type:String)
	{
		super(type);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	override public function clone():Event
	{
		const event:LifecycleEvent = new LifecycleEvent(type);
		event.error = error;
		return event;
	}
}
