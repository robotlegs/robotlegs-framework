//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import robotlegs.bender.framework.api.LifecycleEvent;

	/**
	 * Handles a lifecycle transition
	 *
	 * @private
	 */
	public class LifecycleTransition
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

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a lifecycle transition
		 * @param name The name of the transition
		 * @param lifecycle The associated lifecycle instance
		 */
		public function LifecycleTransition(name:String, lifecycle:Lifecycle)
		{
			_name = name;
			_lifecycle = lifecycle;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * States that this transition is allowed to enter from
		 * @param states Allowed states
		 * @return Self
		 */
		public function fromStates(... states):LifecycleTransition
		{
			for each (var state:String in states)
				_fromStates.push(state);
			return this;
		}

		/**
		 * The states that this transition applies
		 * @param transitionState The state that the target is put into during the transition
		 * @param finalState The state that the target is put into after the transition
		 * @return
		 */
		public function toStates(transitionState:String, finalState:String):LifecycleTransition
		{
			_transitionState = transitionState;
			_finalState = finalState;
			return this;
		}

		/**
		 * The events that the lifecycle will dispatch
		 * @param preTransitionEvent
		 * @param transitionEvent
		 * @param postTransitionEvent
		 * @return Self
		 */
		public function withEvents(preTransitionEvent:String, transitionEvent:String, postTransitionEvent:String):LifecycleTransition
		{
			_preTransitionEvent = preTransitionEvent;
			_transitionEvent = transitionEvent;
			_postTransitionEvent = postTransitionEvent;
			_reverse && _lifecycle.addReversedEventTypes(preTransitionEvent, transitionEvent, postTransitionEvent);
			return this;
		}

		/**
		 * Reverse the dispatch order of this transition
		 * @return Self
		 */
		public function inReverse():LifecycleTransition
		{
			_reverse = true;
			_lifecycle.addReversedEventTypes(_preTransitionEvent, _transitionEvent, _postTransitionEvent);
			return this;
		}

		/**
		 * A handler to run before the transition runs
		 * @param handler Possibly asynchronous before handler
		 * @return Self
		 */
		public function addBeforeHandler(handler:Function):LifecycleTransition
		{
			_dispatcher.addMessageHandler(_name, handler);
			return this;
		}

		/**
		 * Attempts to enter the transition
		 * @param callback Completion callback
		 */
		public function enter(callback:Function = null):void
		{
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
			_dispatcher.dispatchMessage(_name, function(error:Object):void
			{
				// revert state, report error, and exit
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

				// process callback queue (dup and trash for safety)
				const callbacks:Array = _callbacks.concat();
				_callbacks.length = 0;
				for each (var callback:Function in callbacks)
					safelyCallBack(callback, null, _name);

				// dispatch post transition event
				dispatch(_postTransitionEvent);

			}, _reverse);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

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
				const event:LifecycleEvent = new LifecycleEvent(LifecycleEvent.ERROR, error);
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
				throw error;
			}
		}
	}
}
