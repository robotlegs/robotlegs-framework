//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.impl.support
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.view.api.IViewClassInfo;
	import org.robotlegs.v2.view.api.IViewHandler;

	public class ViewHandlerSupport implements IViewHandler
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public function get interests():uint
		{
			return _taskID;
		}

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const BLOCK_1:uint = 0x000002;

		protected const BLOCK_2:uint = 0x000008;

		protected const BLOCK_3:uint = 0x000020;

		protected const BLOCK_4:uint = 0x000080;

		protected const BLOCK_5:uint = 0x000200;

		protected const BLOCK_6:uint = 0x000800;

		protected const BLOCK_7:uint = 0x002000;

		protected const BLOCK_8:uint = 0x008000;

		protected const TASK_1:uint = 0x000001;

		protected const TASK_2:uint = 0x000004;

		protected const TASK_3:uint = 0x000010;

		protected const TASK_4:uint = 0x000040;

		protected const TASK_5:uint = 0x000100;

		protected const TASK_6:uint = 0x000400;

		protected const TASK_7:uint = 0x001000;

		protected const TASK_8:uint = 0x004000;

		protected var _addedHandler:Function;

		protected var _blocked:Boolean;

		protected var _removedHandler:Function;

		protected var _taskID:uint;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ViewHandlerSupport(taskID:uint, blocked:Boolean, addedHandler:Function, removedHandler:Function = null)
		{

			_taskID = taskID && this['TASK_' + taskID];

			if (blocked)
			{
				_taskID &&= _taskID | this['BLOCK_' + taskID];
			}

			_blocked = blocked;
			_addedHandler = addedHandler;
			_removedHandler = removedHandler;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			_addedHandler(view, info);
			return _taskID;
		}

		public function handleViewRemoved(view:DisplayObject):void
		{
			_removedHandler(view);
		}
	}
}
