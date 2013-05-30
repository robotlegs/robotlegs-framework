//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import flash.display.DisplayObjectContainer;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.extensions.viewManager.impl.ContainerBinding;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.StageCrawler;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * View Handlers (like the MediatorMap) handle views as they land on stage.
	 *
	 * This extension checks for views that might already be on the stage
	 * after context initialization and ensures that those views are handled.
	 */
	public class StageCrawlerExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _logger:ILogger;

		private var _injector:IInjector;

		private var _containerRegistry:ContainerRegistry;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			context.afterInitializing(afterInitializing);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function afterInitializing():void
		{
			_containerRegistry = _injector.getInstance(ContainerRegistry);
			_injector.hasDirectMapping(IViewManager)
				? scanViewManagedContainers()
				: scanContextView();
		}

		private function scanViewManagedContainers():void
		{
			_logger.debug("ViewManager is installed. Checking for managed containers...");
			const viewManager:IViewManager = _injector.getInstance(IViewManager);
			for each (var container:DisplayObjectContainer in viewManager.containers)
			{
				container.stage && scanContainer(container);
			}
		}

		private function scanContextView():void
		{
			_logger.debug("ViewManager is not installed. Checking the ContextView...");
			const contextView:ContextView = _injector.getInstance(ContextView);
			contextView.view.stage && scanContainer(contextView.view);
		}

		private function scanContainer(container:DisplayObjectContainer):void
		{
			var binding:ContainerBinding = _containerRegistry.getBinding(container);
			_logger.debug("StageCrawler scanning container {0} ...", [container]);
			new StageCrawler(binding).scan(container);
			_logger.debug("StageCrawler finished scanning {0}", [container]);
		}
	}
}
