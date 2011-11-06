//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewHookMap
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessor;
	import org.robotlegs.v2.extensions.viewManager.api.IViewManager;

	// TODO : This is untested
	public class ViewHookMapExtension implements IContextExtension
	{
		private var context:IContext;

		private var viewHookMap:ViewHookMap;

		private var viewManager:IViewManager;

		public function install(context:IContext):void
		{
			// TODO - these should be installed via their own extension
			context.injector.map(HooksProcessor).asSingleton();
			context.injector.map(GuardsProcessor).asSingleton();
			context.injector.map(HookMap);

			context.injector.map(ViewHookMap).asSingleton();
		}

		public function initialize():void
		{
			viewHookMap = context.injector.getInstance(ViewHookMap);
			viewManager = context.injector.getInstance(IViewManager);
			viewManager.addHandler(viewHookMap);
		}

		public function uninstall():void
		{
			viewManager.removeHandler(viewHookMap);
			context.injector.unmap(ViewHookMap)
		}
	}
}
