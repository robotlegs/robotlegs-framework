//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.ManualStageObserver;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * This extension install a manual Stage Observer
	 */
	public class ManualStageObserverExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		// Really? Yes, there can be only one.
		private static var _manualStageObserver:ManualStageObserver;

		private static var _installCount:uint;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			_installCount++;
			_injector = context.injector;
			_logger = context.getLogger(this);
			context.whenInitializing(whenInitializing);
			context.whenDestroying(whenDestroying);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function whenInitializing():void
		{
			// Hark, an actual Singleton!
			if (!_manualStageObserver)
			{
				const containerRegistry:ContainerRegistry = _injector.getInstance(ContainerRegistry);
				_logger.debug("Creating genuine ManualStageObserver Singleton");
				_manualStageObserver = new ManualStageObserver(containerRegistry);
			}
		}

		private function whenDestroying():void
		{
			_installCount--;
			if (_installCount == 0)
			{
				_logger.debug("Destroying genuine ManualStageObserver Singleton");
				_manualStageObserver.destroy();
				_manualStageObserver = null;
			}
		}
	}
}
