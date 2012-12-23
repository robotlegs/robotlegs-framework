//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.display.DisplayObjectContainer;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * @private
	 */
	public class ViewManagerBasedExistenceWatcher
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _logger:ILogger;

		private var _viewManager:IViewManager;

		private var _parentContext:IContext;

		private var _childContext:IContext;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function ViewManagerBasedExistenceWatcher(context:IContext, viewManager:IViewManager)
		{
			_logger = context.getLogger(this);
			_viewManager = viewManager;
			_parentContext = context;
			_parentContext.lifecycle.whenDestroying(destroy);
			init();
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
			if (_childContext)
			{
				_logger.debug("Unlinking parent injector for child context {0}", [_childContext]);
				_parentContext.removeChild(_childContext);
			}
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
			event.stopImmediatePropagation();
			_childContext = event.context;
			_logger.debug("Context existence event caught. Configuring child context {0}", [_childContext]);
			_parentContext.addChild(_childContext);
		}
	}
}
