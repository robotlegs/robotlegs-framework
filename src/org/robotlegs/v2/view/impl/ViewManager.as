//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.impl
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.view.api.IViewHandler;
	import org.robotlegs.v2.view.api.IViewManager;
	import org.robotlegs.v2.view.api.IViewWatcher;

	public class ViewManager implements IViewManager
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _containers:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>;

		private const _handlers:Vector.<IViewHandler> = new Vector.<IViewHandler>;

		private const _watchers:Vector.<IViewWatcher> = new Vector.<IViewWatcher>;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ViewManager()
		{
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addContainer(container:DisplayObjectContainer):void
		{
			if (_containers.indexOf(container) != -1)
				return;

			_containers.push(container);

			for each (var handler:IViewHandler in _handlers)
			{
				for each (var watcher:IViewWatcher in _watchers)
				{
					watcher.addHandler(handler, container);
				}
			}
		}

		public function addHandler(handler:IViewHandler):void
		{
			if (_handlers.indexOf(handler) != -1)
				return;

			_handlers.push(handler);

			for each (var container:DisplayObjectContainer in _containers)
			{
				for each (var watcher:IViewWatcher in _watchers)
				{
					watcher.addHandler(handler, container);
				}
			}
		}

		public function addWatcher(watcher:IViewWatcher):void
		{
			if (_watchers.indexOf(watcher) != -1)
				return;

			_watchers.push(watcher);

			for each (var handler:IViewHandler in _handlers)
			{
				for each (var container:DisplayObjectContainer in _containers)
				{
					watcher.addHandler(handler, container);
				}
			}
		}

		public function removeContainer(container:DisplayObjectContainer):void
		{
			const index:int = _containers.indexOf(container);
			if (index == -1)
				return;

			_containers.splice(index, 1);

			for each (var handler:IViewHandler in _handlers)
			{
				for each (var watcher:IViewWatcher in _watchers)
				{
					watcher.removeHandler(handler, container);
				}
			}
		}

		public function removeHandler(handler:IViewHandler):void
		{
			const index:int = _handlers.indexOf(handler);
			if (index == -1)
				return;

			_handlers.splice(index, 1);

			for each (var container:DisplayObjectContainer in _containers)
			{
				for each (var watcher:IViewWatcher in _watchers)
				{
					watcher.removeHandler(handler, container);
				}
			}
		}

		public function removeWatcher(watcher:IViewWatcher):void
		{
			const index:int = _watchers.indexOf(watcher);
			if (index == -1)
				return;

			_watchers.splice(index, 1);

			for each (var handler:IViewHandler in _handlers)
			{
				for each (var container:DisplayObjectContainer in _containers)
				{
					watcher.removeHandler(handler, container);
				}
			}
		}
	}
}
