//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.tasks
{
	import flash.events.Event;

	public class TaskHandler implements ITaskHandler
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _taskType:Class;

		public function get taskType():Class
		{
			return _taskType;
		}

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _addedHandler:Function;

		protected var _removedHandler:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function TaskHandler(taskType:Class, useAddedHandler:Function, useRemovedHandler:Function)
		{
			_taskType = taskType;
			_addedHandler = useAddedHandler;
			_removedHandler = useRemovedHandler;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addedHandler(e:Event):uint
		{
			return _addedHandler(e);
		}

		public function removedHandler(e:Event):uint
		{
			if (_removedHandler != null)
			{
				return _removedHandler(e);
			}
			return 0;
		}
	}
}
