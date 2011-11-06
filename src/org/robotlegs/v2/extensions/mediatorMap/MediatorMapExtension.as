//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.guardsAndHooks.api.IGuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.api.IHooksProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessor;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.impl.MediatorMap;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.api.IViewManager;

	public class MediatorMapExtension implements IContextExtension
	{
		private var context:IContext;

		private var viewManager:IViewManager;

		private var mediatorMap:IMediatorMap;

		public function install(context:IContext):void
		{
			this.context = context;
			context.injector.map(IMediatorMap).toSingleton(MediatorMap);

			// TODO: these should be installed via their own extension
			context.injector.map(IGuardsProcessor).toSingleton(GuardsProcessor);
			context.injector.map(IHooksProcessor).toSingleton(HooksProcessor);
		}

		public function initialize():void
		{
			viewManager = context.injector.getInstance(IViewManager);
			mediatorMap = context.injector.getInstance(IMediatorMap);
			// TODO: shouldn't need to cast here. IMediatorMap should extend IViewManager
			viewManager.addHandler(mediatorMap as IViewHandler);
		}

		public function uninstall():void
		{
			viewManager.removeHandler(mediatorMap as IViewHandler);
			context.injector.unmap(IMediatorMap)
		}
	}
}
