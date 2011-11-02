//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guardsAndHooks
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessor;
	import org.robotlegs.v2.extensions.viewManager.api.IViewManager;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HookMap;

	// TODO : This is untested
	public class ViewHookMapExtension implements IContextExtension
	{

		public function initialize(context:IContext):void
		{
			const viewHookMap:ViewHookMap = context.injector.getInstance(ViewHookMap);
			const viewManager:IViewManager = context.injector.getInstance(IViewManager);
			viewManager.addHandler(viewHookMap);
		}

		public function install(context:IContext):void
		{
			// TODO - make these soft mappings
			context.injector.map(HooksProcessor).asSingleton();
			context.injector.map(GuardsProcessor).asSingleton();
			context.injector.map(HookMap);
			context.injector.map(ViewHookMap).asSingleton();
		}

		public function uninstall(context:IContext):void
		{
			// TODO - unmappings
		}
	}

}