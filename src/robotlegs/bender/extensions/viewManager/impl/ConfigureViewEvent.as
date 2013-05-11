//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * View Configuration Event
	 * @private
	 */
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

		/**
		 * The view instance associated with this event
		 */
		public function get view():DisplayObject
		{
			return _view;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a view configuration event
		 * @param type The event type
		 * @param view The associated view instance
		 */
		public function ConfigureViewEvent(type:String, view:DisplayObject = null)
		{
			super(type, true, true);
			_view = view;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new ConfigureViewEvent(type, _view);
		}
	}
}
