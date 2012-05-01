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
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	public class MediatorMapExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _context:IContext;

		private var _injector:Injector;

		private var _mediatorMap:IMediatorMap;

		private var _viewManager:IViewManager;

		private var _mediatorManager:DefaultMediatorManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;
			_injector = context.injector;
			_injector.map(IMediatorFactory).toSingleton(MediatorFactory);
			_injector.map(IMediatorMap).toSingleton(MediatorMap);
			_context.addStateHandler(ManagedObject.PRE_INITIALIZE, handleContextPreInitialize);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextPreInitialize():void
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