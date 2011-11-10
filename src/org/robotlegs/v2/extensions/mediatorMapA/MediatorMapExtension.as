//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMapA.impl.MediatorMap;
	import org.robotlegs.v2.extensions.viewManager.api.IViewManager;

	public class MediatorMapExtension implements IContextExtension
	{
		private var context:IContext;

		private var viewManager:IViewManager;

		private var mediatorMapA:MediatorMap;

		public function install(context:IContext):void
		{
			this.context = context;
			context.injector.map(IMediatorMap).toSingleton(MediatorMap);
		}

		public function initialize():void
		{
			viewManager = context.injector.getInstance(IViewManager);
			mediatorMapA = context.injector.getInstance(IMediatorMap);
			viewManager.addHandler(mediatorMapA);
		}

		public function uninstall():void
		{
			viewManager.removeHandler(mediatorMapA);
			context.injector.unmap(IMediatorMap)
		}
	}
}
