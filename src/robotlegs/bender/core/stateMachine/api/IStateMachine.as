//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.stateMachine.api
{

	public interface IStateMachine
	{
		/**
		 * @return True if the state is changing; false otherwise.
		 */
		function get stateChanging():Boolean;

		/**
		 * @return The current state
		 */
		function get state():String;

		/**
		 * Sets the current state.
		 * @param value A String representation of the state to transition to.
		 */
		function set state(value:String):void;

		/**
		 * Sets the current state.
		 * @param state A String representation of the state to transition to.
		 * @param callback An optional completion callback function
		 */
		function setCurrentState(state:String, callback:Function = null):void;

		/**
		 * Registers a new state along with steps to transition between
		 * @param state A String representation of the state
		 * @param steps An Array of Strings represention steps to transition between
		 * @param reverseNotify Notify step handlers in reverse
		 */
		function addState(state:String, steps:Array, reverseNotify:Boolean = false):void;

		/**
		 * Checks whether the StateMachine has been registered with a given state.
		 * @param state A String representation of the state
		 * @return True if the state has been registered; false otherwise.
		 */
		function hasState(state:String):Boolean;

		/**
		 * Checks whether the StateMachine has been registered with a given step.
		 * @param state A String representation of the step
		 * @return True if the step has been registered; false otherwise.
		 */
		function hasStep(step:String):Boolean;

		/**
		 * Removes a given state for the StateMachine
		 * @param state A String representation of the state
		 */
		function removeState(state:String):void;

		/**
		 * Registers a state step handler with the StateMachine.
		 * @param step A String representation of the step
		 * @param handler The handler function
		 */
		function addStateHandler(step:String, handler:Function):void;

		/**
		 * Removes a state step handler from the StateMachine
		 * @param step A String representation of the step
		 * @param handler The handler function
		 */
		function removeStateHandler(step:String, handler:Function):void;
	}
}
