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
	import org.robotlegs.v2.extensions.viewManager.integration.listeners.AutoStageListener;

	public class AutoStageListenerExtension implements IContextExtension
	{
		private static var installCount:uint;

		// Really? Yes, there can be only one.
		private static var viewListener:IViewListener;
		
		private var context:IContext;

		public function install(context:IContext):void
		{
			this.context = context;
			installCount++;
		}

		public function initialize():void
		{
			if (viewListener == null)
			{
				const containerRegistry:ContainerRegistry = context.injector.getInstance(ContainerRegistry);
				const viewProcessor:ViewProcessor = context.injector.getInstance(ViewProcessor);
				viewListener = new AutoStageListener(viewProcessor, containerRegistry);
			}
		}

		public function uninstall():void
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
