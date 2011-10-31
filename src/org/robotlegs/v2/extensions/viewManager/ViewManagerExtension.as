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
	import org.robotlegs.v2.extensions.viewManager.api.IViewManager;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewManager;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewProcessor;

	public class ViewManagerExtension implements IContextExtension
	{
		// Really? Yes, there can be only one.
		private static var viewProcessor:ViewProcessor;

		public function initialize(context:IContext):void
		{
			context.injector.getInstance(IViewManager);
		}

		public function install(context:IContext):void
		{
			viewProcessor ||= new ViewProcessor();
			context.injector.map(ViewProcessor).toValue(viewProcessor);
			context.injector.map(IViewManager).toSingleton(ViewManager);
		}

		public function uninstall(context:IContext):void
		{
			const viewManager:IViewManager = context.injector.getInstance(IViewManager);
			context.injector.unmap(ViewProcessor);
			context.injector.unmap(IViewManager);
		}
	}
}
