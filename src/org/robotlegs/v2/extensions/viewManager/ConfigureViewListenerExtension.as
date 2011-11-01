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
	import org.robotlegs.v2.extensions.viewManager.api.IViewListener;
	import org.robotlegs.v2.extensions.viewManager.impl.ContainerRegistry;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewProcessor;
	import org.robotlegs.v2.extensions.viewManager.integration.listeners.ConfigureViewListener;

	public class ConfigureViewListenerExtension implements IContextExtension
	{
		private static var installCount:uint;

		// Really? Yes, there can be only one.
		private static var viewListener:IViewListener;

		public function initialize(context:IContext):void
		{
			if (viewListener == null)
			{
				const containerRegistry:ContainerRegistry = context.injector.getInstance(ContainerRegistry);
				const viewProcessor:ViewProcessor = context.injector.getInstance(ViewProcessor);
				viewListener = new ConfigureViewListener(viewProcessor, containerRegistry);
			}
		}

		public function install(context:IContext):void
		{
			installCount++;
		}

		public function uninstall(context:IContext):void
		{
			installCount--;
			if (installCount == 0)
			{
				viewListener.destroy();
				viewListener = null;
			}
		}
	}
}
