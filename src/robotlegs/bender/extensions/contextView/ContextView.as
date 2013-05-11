//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
{
	import flash.display.DisplayObjectContainer;

	/**
	 * The Context View represents the root DisplayObjectContainer for a Context
	 */
	public class ContextView
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _view:DisplayObjectContainer;

		/**
		 * The root DisplayObjectContainer for this Context
		 */
		public function get view():DisplayObjectContainer
		{
			return _view;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * The Context View represents the root DisplayObjectContainer for a Context
		 * @param view The root DisplayObjectContainer for this Context
		 */
		public function ContextView(view:DisplayObjectContainer)
		{
			_view = view;
		}
	}
}
