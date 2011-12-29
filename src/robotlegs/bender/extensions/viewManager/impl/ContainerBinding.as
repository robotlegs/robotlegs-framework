//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObjectContainer;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	public class ContainerBinding
	{

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

		protected var _parent:ContainerBinding;

		public function get parent():ContainerBinding
		{
			return _parent;
		}

		public function set parent(value:ContainerBinding):void
		{
			_parent = value;
		}

		public function ContainerBinding(container:DisplayObjectContainer)
		{
			_container = container;
		}

		public function addHandler(handler:IViewHandler):void
		{
			if (!handler.interests)
				throw new ArgumentError("A handler must be interested in something");
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
