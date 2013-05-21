//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
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

	/**
	 * This extension installs a shared IMediatorMap into the context
	 */
	public class MediatorMapExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _mediatorMap:IMediatorMap;

		private var _viewManager:IViewManager;

		private var _mediatorManager:DefaultMediatorManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			context.beforeInitializing(beforeInitializing)
				.beforeDestroying(beforeDestroying)
				.whenDestroying(whenDestroying)
				.afterDestroying(afterDestroying);
			_injector = context.injector;
			_injector.map(IMediatorFactory).toSingleton(MediatorFactory);
			_injector.map(IMediatorMap).toSingleton(MediatorMap);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function beforeInitializing():void
		{
			_mediatorMap = _injector.getInstance(IMediatorMap);
			_mediatorManager = _injector.instantiateUnmapped(DefaultMediatorManager);
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.addViewHandler(_mediatorMap as IViewHandler);
			}
		}

		private function beforeDestroying():void
		{
			var mediatorFactory:IMediatorFactory = _injector.getInstance(IMediatorFactory);
			mediatorFactory.removeAllMediators();

			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.removeViewHandler(_mediatorMap as IViewHandler);
			}
		}

		private function whenDestroying():void
		{
			if (_injector.satisfiesDirectly(IMediatorMap))
			{
				_injector.unmap(IMediatorMap);
			}
			if (_injector.satisfiesDirectly(IMediatorFactory))
			{
				_injector.unmap(IMediatorFactory);
			}
		}

		private function afterDestroying():void
		{
			_injector = null;
			_mediatorMap = null;
			_viewManager = null;
			_mediatorManager = null;
		}
	}
}
