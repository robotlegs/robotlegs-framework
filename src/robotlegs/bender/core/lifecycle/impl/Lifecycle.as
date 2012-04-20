package robotlegs.bender.core.lifecycle.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.core.messaging.MessageDispatcher;
	import robotlegs.bender.core.lifecycle.api.*;
	
	public final class Lifecycle implements ILifecycle
	{
		public static const UNBORN:LifecycleState = new LifecycleState('Unborn');
		public static const BORN:LifecycleState = new LifecycleState('Born');
		public static const ACTIVE:LifecycleState = new LifecycleState('Active');
		public static const SUSPENDED:LifecycleState = new LifecycleState('Suspended');
		public static const DESTROYED:LifecycleState = new LifecycleState('Destroyed');
		
		public static const BEFORE:Object = {name:'before'};
		public static const WHEN:Object = {name:'when'};
		public static const AFTER:Object = {name:'after'};
		
		// a more explicit expression for when we're returning 'no errors' as null
		private static const NO_ERRORS:Object = null;
		
		private static const DEBUG_HINT:String = " To debug this situation add a processErrorHandler to the lifecycle and inspect the errors passed.";
		
		private const _messageDispatcher:MessageDispatcher = new MessageDispatcher();
		
		private const _dispatchMessagesByTransitionAndTiming:Dictionary = new Dictionary();
		private const _transitionNames:Dictionary = new Dictionary();
		private const _blockingPhases:Array = [BEFORE];
		private const _reverseTransitions:Array = [suspend, destroy];
		
		private var _stateMachine:LifecycleStateMachine;
		private var _invalidTransitionStrategy:Function = doNothing;
		private var _processErrorStategy:Function = doNothing;
		private var _target:Object;
		
		public function Lifecycle(target:Object = null) 
		{
			_target = target;
			prepare();
		} 
		
		public function get target():Object
		{
			return _target;
		}
		
		public function set invalidTransitionHandler(handler:Function):void
		{
			_invalidTransitionStrategy = handler;
		}
		
		public function set processErrorHandler(handler:Function):void
		{
			_processErrorStategy = handler;
		}
		
		public function initialize(actionCallback:Function = null):void
		{
			if(_stateMachine.attemptTransition(doNothing, BORN, null))
				_stateMachine.attemptTransition(initialize, ACTIVE, actionCallback);
		}
		
		public function suspend(actionCallback:Function = null):void
		{
			_stateMachine.attemptTransition(suspend, SUSPENDED, actionCallback);
		}
		
		public function destroy(actionCallback:Function = null):void
		{
			_stateMachine.attemptTransition(destroy, DESTROYED, actionCallback);
		}
		
		public function resume(actionCallback:Function = null):void
		{
			_stateMachine.attemptTransition(resume, ACTIVE, actionCallback);
		}
		
		public function get state():LifecycleState
		{
			return _stateMachine.state;
		}
		
		public function beforeInitializing(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(initialize, BEFORE, handler);
		}
		
		public function whenInitializing(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(initialize, WHEN, handler);
		}
		
		public function afterInitializing(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(initialize, AFTER, handler);
		}
		
		public function beforeSuspending(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(suspend, BEFORE, handler);
		}
		
		public function whenSuspending(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(suspend, WHEN, handler);
		}
		
		public function afterSuspending(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(suspend, AFTER, handler);
		}
		
		public function beforeResuming(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(resume, BEFORE, handler);
		}
		
		public function whenResuming(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(resume, WHEN, handler);
		}
		
		public function afterResuming(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(resume, AFTER, handler);
		}
		
		public function beforeDestroying(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(destroy, BEFORE, handler);
		}
		
		public function whenDestroying(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(destroy, WHEN, handler);
		}
		
		public function afterDestroying(handler:Function):ILifecycleHooks
		{
			return addMessageHandlerFor(destroy, AFTER, handler);
		}
		
		/*
	 		PRIVATE
		*/
		private function prepare():void
		{
			_stateMachine = new LifecycleStateMachine(runTransitionTo, invalidTransitionTo);
			_transitionNames[initialize] = 'initialize';
			_transitionNames[suspend] = 'suspend';
			_transitionNames[resume] = 'resume';
			_transitionNames[destroy] = 'destroy';
		}		
		
		private function addMessageHandlerFor(transition:Function, timing:Object, handler:Function):ILifecycleHooks
		{
			const messageKey:Object = getOrCreateDispatcherMessage(transition, timing);
			_messageDispatcher.addMessageHandler(messageKey, handler);
			return this;
		}
		
		private function runTransitionTo(transition:Function, nextState:LifecycleState, actionCallback:Function):Boolean
		{
			const afterCallback:Function = createAfterCallback(transition, nextState);
			const whenCallback:Function = createWhenCallback(transition, nextState, afterCallback, actionCallback);
			const beforeCallback:Function = createBeforeCallback(transition, nextState, whenCallback, actionCallback);
			
			if(handlersExistFor(transition, BEFORE))
				dispatchMessageFor(transition, BEFORE, beforeCallback);
			else
				beforeCallback(NO_ERRORS);
			
			return true;
		}
		
		private function createAfterCallback(transition:Function, nextState:LifecycleState):Function
		{
			return function(error:Object):void
			{
				handleProcessError(error, transition, nextState, WHEN);
			}
		}
		
		private function createWhenCallback(transition:Function, nextState:LifecycleState, afterCallback:Function, actionCallback:Function):Function
		{
			return function(error:Object):void
			{
				actionCallback && actionCallback(NO_ERRORS);
				handleProcessError(error, transition, nextState, WHEN);
		
				if(handlersExistFor(transition, AFTER))
					dispatchMessageFor(transition, AFTER, afterCallback);
			}
		}
		
		private function createBeforeCallback(transition:Function, nextState:LifecycleState, whenCallback:Function, actionCallback:Function):Function
		{
			return function(error:Object):void
			{
				if(error)
				{
					actionCallback && actionCallback(error);
					handleProcessError(error, transition, nextState, BEFORE);
				}
				else
				{
					_stateMachine.state = nextState;
					if(handlersExistFor(transition, WHEN))
						dispatchMessageFor(transition, WHEN, whenCallback);
					else if(handlersExistFor(transition, AFTER))
						whenCallback(NO_ERRORS);
					else 
						actionCallback && actionCallback(NO_ERRORS);
				}
			}
		}
		
		private function handleProcessError(error:Object, transition:Function, nextState:LifecycleState, timing:Object):void
		{
			if(error == null) return;
			
			if(_processErrorStategy != doNothing)
			{
				const requiredPayload:Array = [error];
				if(_processErrorStategy.length > 1)
					requiredPayload.push(createLifecycleMessage(transition, timing));
				_processErrorStategy.apply(null, requiredPayload);
			}
			else
			{
				const errorDescription:String = describeError(transition, nextState, timing) + DEBUG_HINT;
				throw new LifecycleError(errorDescription);
			}
		}
		
		private function describeError(transition:Function, nextState:LifecycleState, timing:Object):String
		{
			return "Errors were returned by one or more of the handlers " + timing.name + 
					" the " + _transitionNames[transition] + 
					" transition from " + _stateMachine.state.toString() + 
					" to " + nextState.toString() + ".";
		}
		
		private function handlersExistFor(transition:Function, timing:Object):Boolean
		{
			return _dispatchMessagesByTransitionAndTiming[transition] && _dispatchMessagesByTransitionAndTiming[transition][timing];
		}
		
		private function dispatchMessageFor(transition:Function, timing:Object, actionCallback:Function = null):void
		{
			const dispatchOptions:uint = createDispatchOptions(transition, timing);
			_messageDispatcher.dispatchMessage(_dispatchMessagesByTransitionAndTiming[transition][timing], actionCallback, dispatchOptions);
		}
		
		private function createDispatchOptions(transition:Function, timing:Object):uint
		{
			var dispatchOptions:uint = 0;
			if(_blockingPhases.indexOf(timing) > -1)
				dispatchOptions = MessageDispatcher.HALT_ON_ERROR;
			
			if(_reverseTransitions.indexOf(transition) > -1)
				dispatchOptions = dispatchOptions | MessageDispatcher.REVERSE;
			
			return dispatchOptions;
		}
				
		private function doNothing(...rest):Boolean
		{
			return false;
		} 
		
		private function invalidTransitionTo(transition:Function, nextState:LifecycleState, actionCallback:Function):Boolean
		{
			const message:String = 'Invalid ' + _transitionNames[transition] 
									+ ' transition from ' + _stateMachine.state.toString() 
									+ ' to ' + nextState.toString();
			_invalidTransitionStrategy(message);
			return false;
		}
		
		private function getOrCreateDispatcherMessage(transition:Function, timing:Object):Object
		{
			if(!_dispatchMessagesByTransitionAndTiming[transition])
				_dispatchMessagesByTransitionAndTiming[transition] = new Dictionary();

			return _dispatchMessagesByTransitionAndTiming[transition][timing] ||= createLifecycleMessage(transition, timing);
		}
		
		private function createLifecycleMessage(transition:Function, timing:Object):LifecycleMessage
		{
			var transitionName:String = _transitionNames[transition] + "ing";
			transitionName = transitionName.replace('eing','ing');
			const description:String = timing.name + " " + transitionName;
			return new LifecycleMessage(_target, transition, timing, description);		
		}
	}
}