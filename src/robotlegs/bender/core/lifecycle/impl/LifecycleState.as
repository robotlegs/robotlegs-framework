//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.lifecycle.impl
{

	public class LifecycleState
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _description:String;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function LifecycleState(description:String)
		{
			_description = description;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toString():String
		{
			return '[LifecycleState ' + _description + ']';
		}
	}

}

