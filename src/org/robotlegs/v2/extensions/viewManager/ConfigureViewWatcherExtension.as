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
	import org.robotlegs.v2.extensions.viewManager.api.IViewWatcher;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewProcessor;
	import org.robotlegs.v2.extensions.viewManager.utilities.watchers.ConfigureViewWatcher;

	public class ConfigureViewWatcherExtension implements IContextExtension
	{
		private static var installCount:uint;

		// Really? Yes, there can be only one.
		private static var viewWatcher:IViewWatcher;

		public function initialize(context:IContext):void
		{
			const viewProcessor:ViewProcessor = context.injector.getInstance(ViewProcessor);
			if (viewWatcher == null)
			{
				viewWatcher = new ConfigureViewWatcher(viewProcessor.containerRegistry);
				viewWatcher.configure(viewProcessor);
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
				viewWatcher.destroy();
				viewWatcher = null;
			}
		}
	}
}
