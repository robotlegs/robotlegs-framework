//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.stateMachine.impl
{

	public class StateDefinition
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		private var _steps:Array;

		public function get steps():Array
		{
			return _steps.concat();
		}

		private var _reverseNotify:Boolean;

		public function get reverseNotify():Boolean
		{
			return _reverseNotify;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StateDefinition(name:String, steps:Array, reverseNotify:Boolean = false)
		{
			_name = name;
			_steps = steps;
			_reverseNotify = reverseNotify;
		}
	}
}
