//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.display.DisplayObjectContainer;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;

	public class ViewManagerBasedExistenceWatcher
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ViewManagerBasedExistenceWatcher);

		private var _logger:ILogger;

		private var _injector:Injector;

		private var _viewManager:IViewManager;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ViewManagerBasedExistenceWatcher(context:IContext, viewManager:IViewManager)
		{
			_logger = context.getLogger(this);
			_injector = context.injector;
			_viewManager = viewManager;
			context.lifecycle.whenDestroying(destroy);
			init();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function init():void
		{
			for each (var container:DisplayObjectContainer in _viewManager.containers)
			{
				_logger.debug("Adding context existence event listener to container {0}", [container]);
				container.addEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
			}
			_viewManager.addEventListener(ViewManagerEvent.CONTAINER_ADD, onContainerAdd);
			_viewManager.addEventListener(ViewManagerEvent.CONTAINER_REMOVE, onContainerRemove);
		}

		private function destroy():void
		{
			for each (var container:DisplayObjectContainer in _viewManager.containers)
			{
				_logger.debug("Removing context existence event listener from container {0}", [container]);
				container.removeEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
			}
			_viewManager.removeEventListener(ViewManagerEvent.CONTAINER_ADD, onContainerAdd);
			_viewManager.removeEventListener(ViewManagerEvent.CONTAINER_REMOVE, onContainerRemove);
		}

		private function onContainerAdd(event:ViewManagerEvent):void
		{
			_logger.debug("Adding context existence event listener to container {0}", [event.container]);
			event.container.addEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function onContainerRemove(event:ViewManagerEvent):void
		{
			_logger.debug("Removing context existence event listener from container {0}", [event.container]);
			event.container.removeEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function onContextAdd(event:ModularContextEvent):void
		{
			_logger.debug("Context existence event caught. Configuring child context {0}", [event.context]);
			event.stopImmediatePropagation();
			event.context.injector.parentInjector = _injector;
		}
	}
}
