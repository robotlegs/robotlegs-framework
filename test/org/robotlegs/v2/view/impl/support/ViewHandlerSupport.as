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

		protected var _interests:uint;

		public function get interests():uint
		{
			return _interests;
		}

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const BLOCK_0:uint = 0x000000;

		protected const BLOCK_1:uint = 0x000002;

		protected const BLOCK_2:uint = 0x000008;

		protected const BLOCK_3:uint = 0x000020;

		protected const BLOCK_4:uint = 0x000080;

		protected const BLOCK_5:uint = 0x000200;

		protected const BLOCK_6:uint = 0x000800;

		protected const BLOCK_7:uint = 0x002000;

		protected const BLOCK_8:uint = 0x008000;


		protected const TASK_0:uint = 0x000000;

		protected const TASK_1:uint = 0x000001;

		protected const TASK_2:uint = 0x000004;

		protected const TASK_3:uint = 0x000010;

		protected const TASK_4:uint = 0x000040;

		protected const TASK_5:uint = 0x000100;

		protected const TASK_6:uint = 0x000400;

		protected const TASK_7:uint = 0x001000;

		protected const TASK_8:uint = 0x004000;


		protected var _addedHandler:Function;

		protected var _removedHandler:Function;

		protected var _response:uint;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ViewHandlerSupport(taskID:uint, blocking:Boolean, addedHandler:Function, removedHandler:Function = null)
		{
			_interests = this['TASK_' + taskID];
			_response = _interests;

			if (blocking)
			{
				_response = _interests | this['BLOCK_' + taskID];
			}

			_addedHandler = addedHandler;
			_removedHandler = removedHandler;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			_addedHandler(view, info, _response);
			return _response;
		}

		public function handleViewRemoved(view:DisplayObject):void
		{
			_removedHandler(view);
		}
	}
}
