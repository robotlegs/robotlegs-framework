//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.displayList
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.displayList.api.IViewManager;
	import org.robotlegs.v2.extensions.displayList.impl.StageWatcher;
	import org.robotlegs.v2.extensions.displayList.impl.ViewManager;

	public class DisplayListExtension implements IContextExtension
	{
		// Really? Yes, there can be only one.
		private static const stageWatcher:StageWatcher = new StageWatcher();

		public function initialize(context:IContext):void
		{
			const viewManager:IViewManager = context.injector.getInstance(IViewManager);
			viewManager.addWatcher(stageWatcher);
		}

		public function install(context:IContext):void
		{
			context.injector.map(IViewManager).toSingleton(ViewManager);
		}

		public function uninstall(context:IContext):void
		{
			const viewManager:IViewManager = context.injector.getInstance(IViewManager);
			viewManager.removeWatcher(stageWatcher);
			context.injector.unmap(IViewManager);
		}
	}
}
