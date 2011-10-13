//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.impl
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.view.api.IContainerBinding;
	import org.robotlegs.v2.view.api.IViewHandler;

	public class ContainerBinding implements IContainerBinding
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _container:DisplayObjectContainer;

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		protected const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>;

		public function get handlers():Vector.<IViewHandler>
		{
			return _handlers;
		}

		protected var _parent:IContainerBinding;

		public function get parent():IContainerBinding
		{
			return _parent;
		}

		public function set parent(value:IContainerBinding):void
		{
			_parent = value;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ContainerBinding(container:DisplayObjectContainer)
		{
			_container = container;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addHandler(handler:IViewHandler):void
		{
			if (_handlers.indexOf(handler) == -1)
				_handlers.push(handler);
		}

		public function removeHandler(handler:IViewHandler):void
		{
			const index:int = _handlers.indexOf(handler);
			if (index > -1)
				_handlers.splice(index, 1);
		}
	}
}
