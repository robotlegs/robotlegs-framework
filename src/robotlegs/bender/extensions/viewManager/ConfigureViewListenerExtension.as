//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import robotlegs.bender.extensions.viewManager.api.IViewListener;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.ViewProcessor;
	import robotlegs.bender.extensions.viewManager.integration.listeners.ConfigureViewListener;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	public class ConfigureViewListenerExtension implements IContextConfig
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		// Really? Yes, there can be only one.
		private static var _viewListener:IViewListener;

		private static var _installCount:uint;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _context:IContext;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configureContext(context:IContext):void
		{
			_installCount++;
			_context = context;
			_context.addStateHandler(ManagedObject.SELF_INITIALIZE, handleContextSelfInitialize);
			_context.addStateHandler(ManagedObject.SELF_DESTROY, handleContextSelfDestroy);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextSelfInitialize():void
		{
			if (_viewListener == null)
			{
				const containerRegistry:ContainerRegistry = _context.injector.getInstance(ContainerRegistry);
				const viewProcessor:ViewProcessor = _context.injector.getInstance(ViewProcessor);
				_viewListener = new ConfigureViewListener(viewProcessor, containerRegistry);
			}
		}

		private function handleContextSelfDestroy():void
		{
			_installCount--;
			if (_installCount == 0)
			{
				_viewListener.destroy();
				_viewListener = null;
			}
		}
	}
}
