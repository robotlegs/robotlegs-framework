//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class ConfigureViewEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const CONFIGURE_VIEW:String = 'configureView';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _view:DisplayObject;

		public function get view():DisplayObject
		{
			return _view;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ConfigureViewEvent(type:String, view:DisplayObject = null)
		{
			super(type, true, true);
			_view = view;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function clone():Event
		{
			return new ConfigureViewEvent(type, _view);
		}
	}
}
