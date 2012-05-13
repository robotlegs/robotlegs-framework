//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.impl.DefaultMediatorManager;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.UID;

	public class MediatorMapExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(MediatorMapExtension);

		private var _injector:Injector;

		private var _mediatorMap:IMediatorMap;

		private var _viewManager:IViewManager;

		private var _mediatorManager:DefaultMediatorManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_injector = context.injector;
			_injector.map(IMediatorFactory).toSingleton(MediatorFactory);
			_injector.map(IMediatorMap).toSingleton(MediatorMap);
			context.lifecycle.beforeInitializing(beforeInitializing);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function beforeInitializing():void
		{
			_mediatorMap = _injector.getInstance(IMediatorMap);
			_mediatorManager = _injector.getInstance(DefaultMediatorManager);
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.addViewHandler(_mediatorMap as IViewHandler);
			}
		}
	}
}
