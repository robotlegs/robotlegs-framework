//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * This extension installs a shared IMediatorMap into the context
	 */
	public class MediatorMapExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:IInjector;

		private var _mediatorMap:MediatorMap;

		private var _viewManager:IViewManager;

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
				.whenDestroying(whenDestroying);
			_injector = context.injector;
			_injector.map(IMediatorMap).toSingleton(MediatorMap);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function beforeInitializing():void
		{
			_mediatorMap = _injector.getInstance(IMediatorMap);
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.addViewHandler(_mediatorMap);
			}
		}

		private function beforeDestroying():void
		{
			_mediatorMap.unmediateAll();
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.removeViewHandler(_mediatorMap);
			}
		}

		private function whenDestroying():void
		{
			if (_injector.satisfiesDirectly(IMediatorMap))
			{
				_injector.unmap(IMediatorMap);
			}
		}
	}
}
