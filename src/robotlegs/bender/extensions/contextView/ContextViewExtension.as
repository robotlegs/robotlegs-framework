//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
{
	import robotlegs.bender.extensions.matching.instanceOfType;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * <p>This Extension waits for a ContextView to be added as a configuration
	 * and maps it into the context's injector.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class ContextViewExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:IInjector;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			context.beforeInitializing(beforeInitializing);
			context.addConfigHandler(instanceOfType(ContextView), handleContextView);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextView(contextView:ContextView):void
		{
			if (_injector.hasDirectMapping(ContextView))
			{
				_logger.warn('A contextView has already been installed, ignoring {0}', [contextView.view]);
			}
			else
			{
				_logger.debug("Mapping {0} as contextView", [contextView.view]);
				_injector.map(ContextView).toValue(contextView);
			}
		}

		private function beforeInitializing():void
		{
			if (!_injector.hasDirectMapping(ContextView))
			{
				_logger.error("A ContextView must be installed if you install the ContextViewExtension.");
			}
		}
	}
}
