//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	public class ViewManagerEvent extends Event
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const CONTAINER_ADD:String = 'containerAdd';

		public static const CONTAINER_REMOVE:String = 'containerRemove';

		public static const HANDLER_ADD:String = 'handlerAdd';

		public static const HANDLER_REMOVE:String = 'handlerRemove';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _container:DisplayObjectContainer;

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		private var _handler:IViewHandler;

		public function get handler():IViewHandler
		{
			return _handler;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ViewManagerEvent(type:String, container:DisplayObjectContainer = null, handler:IViewHandler = null)
		{
			super(type);
			_container = container;
			_handler = handler;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function clone():Event
		{
			return new ViewManagerEvent(type, _container, _handler);
		}
	}
}
