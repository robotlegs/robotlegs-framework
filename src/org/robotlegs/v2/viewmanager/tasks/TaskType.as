//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.tasks
{

	public class TaskType
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _type:String;

		public function get type():String
		{
			return _type;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function TaskType(type:String)
		{
			_type = type;
		}
	}
}
