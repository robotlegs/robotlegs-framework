//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
{
	import flash.display.DisplayObjectContainer;

	public class ContextView
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _view:DisplayObjectContainer;

		public function get view():DisplayObjectContainer
		{
			return _view;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ContextView(view:DisplayObjectContainer)
		{
			_view = view;
		}
	}
}
