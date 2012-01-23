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
		function get stateChanging():Boolean;

		function get state():String;
		function set state(value:String):void;

		function setCurrentState(state:String, callback:Function = null):void;

		function addState(state:String, steps:Array, reverseNotify:Boolean = false):void;
		function hasState(state:String):Boolean;
		function hasStep(step:String):Boolean;
		function removeState(state:String):void;

		function addStateHandler(step:String, handler:Function):void;
		function removeStateHandler(step:String, handler:Function):void;
	}
}
