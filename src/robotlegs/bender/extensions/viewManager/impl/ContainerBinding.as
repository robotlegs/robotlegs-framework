//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	[Event(name="bindingEmpty", type="robotlegs.bender.extensions.viewManager.impl.ContainerBindingEvent")]
	public class ContainerBinding extends EventDispatcher
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _parent:ContainerBinding;

		public function get parent():ContainerBinding
		{
			return _parent;
		}

		public function set parent(value:ContainerBinding):void
		{
			_parent = value;
		}

		private var _container:DisplayObjectContainer;

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function get numHandlers():uint
		{
			return _handlers.length;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>;

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
			if (_handlers.indexOf(handler) > -1)
				return;
			_handlers.push(handler);
		}

		public function removeHandler(handler:IViewHandler):void
		{
			const index:int = _handlers.indexOf(handler);
			if (index > -1)
			{
				_handlers.splice(index, 1);
				if (_handlers.length == 0)
				{
					dispatchEvent(new ContainerBindingEvent(ContainerBindingEvent.BINDING_EMPTY));
				}
			}
		}

		public function handleView(view:DisplayObject, type:Class):void
		{
			const length:uint = _handlers.length;
			for (var i:int = 0; i < length; i++)
			{
				var handler:IViewHandler = _handlers[i] as IViewHandler;
				handler.handleView(view, type);
			}
		}
	}
}
