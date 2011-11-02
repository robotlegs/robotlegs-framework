//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.extensions.mediatorMap.impl.MediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	
	import org.robotlegs.v2.extensions.viewManager.api.IViewManager;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessor;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;
	import org.robotlegs.v2.extensions.eventMap.impl.EventMap;
	
	public class MediatorMapExtension implements IContextExtension
	{
		
		public function initialize(context:IContext):void
		{
			const viewManager:IViewManager = context.injector.getInstance(IViewManager);
			const mediatorMap:IViewHandler = context.injector.getInstance(IMediatorMap) as IViewHandler;
			viewManager.addHandler(mediatorMap);
		}

		public function install(context:IContext):void
		{	
			context.injector.map(IEventMap).toType(EventMap);
			context.injector.map(IMediatorMap).toSingleton(MediatorMap);
			context.injector.map(GuardsProcessor).asSingleton();
			context.injector.map(HooksProcessor).asSingleton();
		}

		public function uninstall(context:IContext):void
		{
			
		}
	}
}