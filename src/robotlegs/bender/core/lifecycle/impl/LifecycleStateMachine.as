package robotlegs.bender.core.lifecycle.impl
{
	import flash.utils.Dictionary;
	
	internal final class LifecycleStateMachine
	{		
		private const _transitionsByState:Dictionary = new Dictionary();
		private var _invalidTransitionStrategy:Function;
		private var _validTransitionStrategy:Function;
		private var _state:LifecycleState;
				
		public function LifecycleStateMachine(validTransitionStrategy:Function, invalidTransitionStrategy:Function) 
		{
			_invalidTransitionStrategy = invalidTransitionStrategy;
			_validTransitionStrategy = validTransitionStrategy;
			_state = Lifecycle.UNBORN;
			createStateMap();
		} 
		
		public function get state():LifecycleState
		{
			return _state;
		}
		
		public function set state(value:LifecycleState):void
		{
			_state = value;
		}
		
		/*
	 		PRIVATE
		*/
		
		public function attemptTransition(transition:Function, nextState:LifecycleState, actionCallback:Function):Boolean
		{
			return _transitionsByState[_state][nextState](transition, nextState, actionCallback);
		}

		private function doNothing(...rest):Boolean
		{
			return false;
		} 
		
		private function runTransitionTo(transition:Function, nextState:LifecycleState, actionCallback:Function):Boolean
		{
			_validTransitionStrategy(transition, nextState, actionCallback);
			return true;
		}
		
		private function invalidTransitionTo(transition:Function, nextState:LifecycleState, actionCallback:Function):Boolean
		{
			_invalidTransitionStrategy(transition, nextState, actionCallback);
			return false;
		}
		
		private function createStateMap():void
		{
			_transitionsByState[Lifecycle.UNBORN] = new Dictionary();
			_transitionsByState[Lifecycle.BORN] = new Dictionary();
			_transitionsByState[Lifecycle.ACTIVE] = new Dictionary();
			_transitionsByState[Lifecycle.SUSPENDED] = new Dictionary();
			_transitionsByState[Lifecycle.DESTROYED] = new Dictionary();
			
			_transitionsByState[Lifecycle.UNBORN][Lifecycle.BORN] = runTransitionTo;
			_transitionsByState[Lifecycle.UNBORN][Lifecycle.ACTIVE] = invalidTransitionTo;
			_transitionsByState[Lifecycle.UNBORN][Lifecycle.SUSPENDED] = invalidTransitionTo;
			_transitionsByState[Lifecycle.UNBORN][Lifecycle.DESTROYED] = invalidTransitionTo;

			_transitionsByState[Lifecycle.BORN][Lifecycle.BORN] = doNothing;
			_transitionsByState[Lifecycle.BORN][Lifecycle.ACTIVE] = runTransitionTo;
			_transitionsByState[Lifecycle.BORN][Lifecycle.SUSPENDED] = invalidTransitionTo;
			_transitionsByState[Lifecycle.BORN][Lifecycle.DESTROYED] = invalidTransitionTo;
			
			_transitionsByState[Lifecycle.ACTIVE][Lifecycle.BORN] = invalidTransitionTo;
			_transitionsByState[Lifecycle.ACTIVE][Lifecycle.ACTIVE] = invalidTransitionTo;
			_transitionsByState[Lifecycle.ACTIVE][Lifecycle.SUSPENDED] = runTransitionTo;
			_transitionsByState[Lifecycle.ACTIVE][Lifecycle.DESTROYED] = runTransitionTo;
			
			_transitionsByState[Lifecycle.SUSPENDED][Lifecycle.BORN] = invalidTransitionTo;
			_transitionsByState[Lifecycle.SUSPENDED][Lifecycle.ACTIVE] = runTransitionTo;
			_transitionsByState[Lifecycle.SUSPENDED][Lifecycle.SUSPENDED] = doNothing;
			_transitionsByState[Lifecycle.SUSPENDED][Lifecycle.DESTROYED] = runTransitionTo;
			
			_transitionsByState[Lifecycle.DESTROYED][Lifecycle.BORN] = invalidTransitionTo;
			_transitionsByState[Lifecycle.DESTROYED][Lifecycle.ACTIVE] = invalidTransitionTo;
			_transitionsByState[Lifecycle.DESTROYED][Lifecycle.SUSPENDED] = invalidTransitionTo;
			_transitionsByState[Lifecycle.DESTROYED][Lifecycle.DESTROYED] = doNothing;
		}		
	}
}