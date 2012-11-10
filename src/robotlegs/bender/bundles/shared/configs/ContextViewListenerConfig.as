//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.shared.configs
{
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;

	/**
	 * This configuration file adds the ContextView to the viewManager.
	 *
	 * It requires the ViewManagerExtension, ContextViewExtension
	 * and a ContextView have been installed.
	 */
	public class ContextViewListenerConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var contextView:ContextView;

		[Inject]
		public var viewManager:IViewManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[PostConstruct]
		public function init():void
		{
			viewManager.addContainer(contextView.view);
		}
	}
}
