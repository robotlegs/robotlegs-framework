//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.viewManager.api.IContainerRegistry;
	import org.robotlegs.v2.extensions.viewManager.api.IViewManager;
	import org.robotlegs.v2.extensions.viewManager.api.IViewProcessor;
	import org.robotlegs.v2.extensions.viewManager.impl.ContainerRegistry;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewManager;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewProcessor;

	public class ViewManagerExtension implements IContextExtension
	{
		private static var containerRegistry:IContainerRegistry;

		// Really? Yes, there can be only one.
		private static var viewProcessor:IViewProcessor;

		public function initialize(context:IContext):void
		{
			context.injector.getInstance(IViewManager);
		}

		public function install(context:IContext):void
		{
			// Just one Container Registry
			containerRegistry ||= new ContainerRegistry();
			context.injector.map(IContainerRegistry).toValue(containerRegistry);

			// And just one View Processor
			viewProcessor ||= new ViewProcessor(containerRegistry);
			context.injector.map(IViewProcessor).toValue(viewProcessor);

			// But you get your own View Manager
			context.injector.map(IViewManager).toSingleton(ViewManager);
		}

		public function uninstall(context:IContext):void
		{
			const viewManager:IViewManager = context.injector.getInstance(IViewManager);
			viewManager.removeAll();
			context.injector.unmap(IViewManager);
			context.injector.unmap(IViewProcessor);
			context.injector.unmap(IContainerRegistry);
		}
	}
}
