//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.shared.configs
{
	import flash.display.DisplayObjectContainer;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;

	/**
	 * This simple configuration adds the mapped DisplayObjectContainer ("contextView")
	 * to the viewManager.
	 */
	public class ContextViewListenerConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var contextView:DisplayObjectContainer;

		[Inject]
		public var viewManager:IViewManager;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[PostConstruct]
		public function init():void
		{
			viewManager.addContainer(contextView);
		}
	}
}
