//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.UID;

	public class ViewManagerExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		// Really? Yes, there can be only one.
		private static var _containerRegistry:ContainerRegistry;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ViewManagerExtension);

		private var _injector:Injector;

		private var _viewManager:IViewManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_injector = context.injector;

			// Just one Container Registry
			_containerRegistry ||= new ContainerRegistry();
			_injector.map(ContainerRegistry).toValue(_containerRegistry);

			// But you get your own View Manager
			_injector.map(IViewManager).toSingleton(ViewManager);

			context.lifecycle.whenInitializing(whenInitializing);
			context.lifecycle.whenDestroying(whenDestroying);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function whenInitializing():void
		{
			_viewManager = _injector.getInstance(IViewManager);
		}

		private function whenDestroying():void
		{
			_viewManager.removeAllHandlers();
			_injector.unmap(IViewManager);
			_injector.unmap(ContainerRegistry);
		}
	}
}
