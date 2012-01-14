//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager;
	import robotlegs.bender.extensions.viewManager.impl.ViewProcessor;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	public class ViewManagerExtension implements IContextConfig
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		// Really? Yes, there can be only one.
		private static var _containerRegistry:ContainerRegistry;

		// Really? Yes, there can be only one.
		private static var _viewProcessor:ViewProcessor;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _context:IContext;

		private var _viewManager:IViewManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configureContext(context:IContext):void
		{
			_context = context;

			// Just one Container Registry
			_containerRegistry ||= new ContainerRegistry();
			_context.injector.map(ContainerRegistry).toValue(_containerRegistry);

			// And just one View Processor
			_viewProcessor ||= new ViewProcessor(_containerRegistry);
			_context.injector.map(ViewProcessor).toValue(_viewProcessor);

			// But you get your own View Manager
			_context.injector.map(IViewManager).toSingleton(ViewManager);

			_context.addStateHandler(ManagedObject.SELF_INITIALIZE, handleContextSelfInitialize);
			_context.addStateHandler(ManagedObject.SELF_DESTROY, handleContextSelfDestroy);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextSelfInitialize():void
		{
			_viewManager = _context.injector.getInstance(IViewManager);
		}

		private function handleContextSelfDestroy():void
		{
			_viewManager.destroy();
			_context.injector.unmap(IViewManager);
			_context.injector.unmap(ViewProcessor);
			_context.injector.unmap(ContainerRegistry);
		}
	}
}
