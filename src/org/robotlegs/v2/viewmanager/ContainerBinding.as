//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObjectContainer;

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
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _removeHandler:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ContainerBinding(container:DisplayObjectContainer, removeHandler:Function)
		{
			_container = container;
			_removeHandler = removeHandler;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function remove():IContainerBinding
		{
			_removeHandler(this);
			return this;
		}
	}
}
