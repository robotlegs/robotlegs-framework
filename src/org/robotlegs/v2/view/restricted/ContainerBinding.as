//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.restricted
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.view.api.IContainerBinding;
	import org.robotlegs.v2.view.api.IViewHandler;

	public class ContainerBinding implements IContainerBinding
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _children:Vector.<IContainerBinding>;

		public function get children():Vector.<IContainerBinding>
		{
			return _children;
		}

		public function set children(value:Vector.<IContainerBinding>):void
		{
			_children = value;
		}


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


		private var _parent:IContainerBinding;

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

		public function ContainerBinding(container:DisplayObjectContainer, handler:IViewHandler)
		{
			_container = container;
			_handler = handler;
		}
	}
}
