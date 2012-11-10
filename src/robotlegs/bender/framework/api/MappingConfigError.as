//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	public class MappingConfigError extends Error
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _trigger:Object;

		public function get trigger():Object
		{
			return _trigger;
		}

		private var _action:Object;

		public function get action():Object
		{
			return _action;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MappingConfigError(message:String, trigger:*, action:*)
		{
			super(message);

			_trigger = trigger;
			_action = action;
		}
	}
}
