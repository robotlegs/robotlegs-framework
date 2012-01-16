//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.support
{
	import flash.display.DisplayObject;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	public class CallbackViewHandler implements IViewHandler
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _callback:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CallbackViewHandler(callback:Function = null)
		{
			_callback = callback;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function handleView(view:DisplayObject, type:Class):void
		{
			_callback && _callback(view, type);
		}
	}
}
