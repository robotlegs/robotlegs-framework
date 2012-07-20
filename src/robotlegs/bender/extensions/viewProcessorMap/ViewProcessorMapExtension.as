//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.viewProcessorMap.impl.IViewProcessorFactory;
	import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewProcessorFactory;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewProcessorMap;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.UID;
	import robotlegs.bender.extensions.viewProcessorMap.impl.IViewProcessorFactory;

	public class ViewProcessorMapExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ViewProcessorMapExtension);

		private var _injector:Injector;

		private var _viewProcessorMap:IViewProcessorMap;

		private var _viewManager:IViewManager;

		private var _viewProcessorFactory:IViewProcessorFactory;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_injector = context.injector;
			_injector.map(IViewProcessorFactory).toSingleton(ViewProcessorFactory);
			_injector.map(IViewProcessorMap).toSingleton(ViewProcessorMap);
			context.lifecycle.beforeInitializing(beforeInitializing);
			context.lifecycle.beforeDestroying(beforeDestroying);
			context.lifecycle.whenDestroying(whenDestroying);
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
			_viewProcessorMap = _injector.getInstance(IViewProcessorMap);
			_viewProcessorFactory = _injector.getInstance(IViewProcessorFactory);
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.addViewHandler(_viewProcessorMap as IViewHandler);
			}
		}
		
		private function beforeDestroying():void
		{
			_viewProcessorFactory.runAllUnprocessors();
			
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_viewManager = _injector.getInstance(IViewManager);
				_viewManager.removeViewHandler(_viewProcessorMap as IViewHandler);
			}
		}
		
		private function whenDestroying():void
		{
			if (_injector.satisfiesDirectly(IViewProcessorMap))
			{
				_injector.unmap(IViewProcessorMap);
			}
			if (_injector.satisfiesDirectly(IViewProcessorFactory))
			{
				_injector.unmap(IViewProcessorFactory);
			}
		}
	}
}