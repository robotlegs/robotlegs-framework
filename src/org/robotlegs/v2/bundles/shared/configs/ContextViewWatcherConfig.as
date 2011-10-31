//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.shared.configs
{
	import flash.display.DisplayObjectContainer;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;
	import org.robotlegs.v2.extensions.displayList.api.IViewManager;

	public class ContextViewWatcherConfig implements IContextConfig
	{

		private static const logger:ILogger = getLogger(ContextViewWatcherConfig);

		[Inject]
		public var contextView:DisplayObjectContainer;

		[Inject]
		public var viewManager:IViewManager;

		public function configure(context:IContext):void
		{
			if (contextView)
			{
				viewManager.addContainer(contextView);
			}
			else
			{
				logger.warn('a ContextViewWatcherConfig was installed into {0}, but the contextView is null. Consider removing this config.', [context]);
			}
		}
	}
}
