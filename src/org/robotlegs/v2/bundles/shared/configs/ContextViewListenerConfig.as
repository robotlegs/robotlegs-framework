//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.shared.configs
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;
	import org.robotlegs.v2.core.api.ILogger;
	import org.robotlegs.v2.extensions.viewManager.api.IViewManager;

	public class ContextViewListenerConfig implements IContextConfig
	{

		[Inject]
		public var contextView:DisplayObjectContainer;

		[Inject]
		public var viewManager:IViewManager;

		[Inject]
		public var logger:ILogger;

		public function configure(context:IContext):void
		{
			if (contextView)
			{
				logger.info('adding contextView to viewManager. Note: avoid this where performance is critical.');
				viewManager.addContainer(contextView);
			}
			else
			{
				logger.warn('a ContextViewListenerConfig was installed into {0}, but the contextView is null. Consider removing this config.');
			}
		}
	}
}
