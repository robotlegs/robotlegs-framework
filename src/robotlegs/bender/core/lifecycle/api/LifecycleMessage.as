//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.lifecycle.api
{

	public class LifecycleMessage
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _transition:Function;

		public function get transition():Function
		{
			return _transition;
		}

		private var _timing:Object;

		public function get timing():Object
		{
			return _timing;
		}

		private var _description:String;

		public function get description():String
		{
			return _description;
		}

		private var _target:Object;

		public function get target():Object
		{
			return _target;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function LifecycleMessage(target:Object, transition:Function, timing:Object, description:String)
		{
			_target = target;
			_transition = transition;
			_timing = timing;
			_description = description;
		}
	}
}
