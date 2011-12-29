//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextExtension;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.extensions.viewMap.impl.ViewMap;

	public class MediatorMapExtension implements IContextExtension
	{
		private var context:IContext;

		private var viewManager:IViewManager;

		private var mediatorMap:MediatorMap;

		public function install(context:IContext):void
		{
			this.context = context;
			context.injector.map(ViewMap).toType(ViewMap);
			context.injector.map(IMediatorMap).toSingleton(MediatorMap);
		}

		public function initialize():void
		{
			viewManager = context.injector.getInstance(IViewManager);
			mediatorMap = context.injector.getInstance(IMediatorMap);
			viewManager.addHandler(mediatorMap);
		}

		public function uninstall():void
		{
			viewManager.removeHandler(mediatorMap);
			context.injector.unmap(IMediatorMap)
		}
	}
}