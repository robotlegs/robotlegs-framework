//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.stateMachine.impl
{
	import robotlegs.bender.core.async.safelyCallBack;
	import robotlegs.bender.core.messaging.IMessageDispatcher;
	import robotlegs.bender.core.messaging.MessageDispatcher;
	import robotlegs.bender.core.stateMachine.api.IStateMachine;

	public class StateMachine implements IStateMachine
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function get state():String
		{
			return _currentState;
		}

		/**
		 * @inheritDoc
		 */
		public function set state(value:String):void
		{
			setCurrentState(value);
		}

		private var _stateChanging:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get stateChanging():Boolean
		{
			return _stateChanging;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _states:Object = {};

		private const _stateNames:Array = [];

		private const _stepNames:Array = [];

		private var _messageDispatcher:IMessageDispatcher;

		private var _currentState:String;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * todo: intro
		 *
		 * @param messageDispatcher The message dispatcher to dispatch step messages on
		 */
		public function StateMachine(messageDispatcher:IMessageDispatcher = null)
		{
			_messageDispatcher = messageDispatcher || new MessageDispatcher();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function addState(state:String, steps:Array, reverseNotify:Boolean = false):void
		{
			addStateDefinition(new StateDefinition(state, steps, reverseNotify));
		}

		/**
		 * @inheritDoc
		 */
		public function removeState(state:String):void
		{
			if (hasState(state))
			{
				// todo: remove all step handlers for this state
				delete _states[state];
				rebuildStateAndStepsNames();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hasState(state:String):Boolean
		{
			return _states[state];
		}

		/**
		 * @inheritDoc
		 */
		public function hasStep(step:String):Boolean
		{
			return _stepNames.indexOf(step) != -1;
		}

		/**
		 * @inheritDoc
		 */
		public function addStateHandler(step:String, handler:Function):void
		{
			_messageDispatcher.addMessageHandler(step, handler);
		}

		/**
		 * @inheritDoc
		 */
		public function removeStateHandler(step:String, handler:Function):void
		{
			_messageDispatcher.removeMessageHandler(step, handler);
		}

		/**
		 * @inheritDoc
		 */
		public function setCurrentState(state:String, callback:Function = null):void
		{
			if (_currentState == state)
				return;

			_stateChanging && throwError('Can not change state while the state is changing. Current state: ' + _currentState);
			hasState(state) || throwError('Invalid state. No state named: ' + state);

			_currentState = state;
			_stateChanging = true;

			// todo: can optimise by checking if any of the steps have handlers
			const definition:StateDefinition = getState(state);

			next(
				definition.steps.reverse(),
				definition.reverseNotify,
				function(error:Object = null):void {
					_stateChanging = false;
					callback && safelyCallBack(callback, error);
				});
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addStateDefinition(state:StateDefinition):void
		{
			validate(state);
			_states[state.name] = state;
			rebuildStateAndStepsNames();
		}

		private function getState(state:String):StateDefinition
		{
			return _states[state];
		}

		/**
		 * Possibly recursive step runner
		 *
		 * @param steps The remaining steps to notify
		 * @param reverseDispatch Reverse notification order
		 * @param callback The eventual callback
		 */
		private function next(steps:Array, reverseDispatch:Boolean, callback:Function):void
		{
			// Try to keep things synchronous with a simple loop,
			// forcefully breaking out for async handlers and recursing.
			// We do this to avoid increasing the stack depth unnecessarily.
			var step:String;
			while (step = steps.pop())
			{
				if (_messageDispatcher.hasMessageHandler(step))
				{
					_messageDispatcher.dispatchMessage(step, function(error:Object):void {
						if (error || steps.length == 0)
						{
							// note: we don't need to safelyCallBack
							// as we provided a known callback in setCurrentState
							callback(error);
						}
						else
						{
							next(steps, reverseDispatch, callback);
						}
					}, reverseDispatch);
					// IMPORTANT: MUST break this loop with a RETURN. See above.
					return;
				}
			}
			// If we got here then this loop finished synchronously.
			// Nobody broke out, so we are done.
			// This relies on the various return statements above. Be careful.
			callback();
		}

		/**
		 * todo: justify this
		 */
		private function rebuildStateAndStepsNames():void
		{
			_stateNames.length = 0;
			_stepNames.length = 0;
			for each (var state:StateDefinition in _states)
			{
				_stateNames.push(state.name);
				_stepNames.splice.apply(null, [0, 0].concat(state.steps));
			}
		}

		/**
		 * Helper to validate that no state or step names exists with the same name
		 * and that none are blank
		 */
		private function validate(definition:StateDefinition):void
		{
			const state:String = definition.name;
			const steps:Array = definition.steps;
			state || throwError('Invalid state name. State name can not be blank or null.');
			steps || throwError('Invalid steps. Steps can not be null.');
			steps.length > 0 || throwError('Invalid steps. Steps can not be empty.');
			hasState(state) && throwError('Invalid state name. A state already exists with this name: ' + state);
			hasStep(state) && throwError('Invalid state name. A step already exists with this name: ' + state);
			for each (var step:String in steps)
			{
				step || throwError('Invalid step name. Step name can not be blank or null.');
				hasState(step) && throwError('Invalid step name. A state already exists with this name: ' + step);
				hasStep(step) && throwError('Invalid step name. A step already exists with this name: ' + step);
			}
		}

		private function throwError(message:String):void
		{
			throw new Error(message);
		}
	}
}
