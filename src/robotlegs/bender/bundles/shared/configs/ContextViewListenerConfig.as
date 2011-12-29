//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.shared.configs
{
	import flash.display.DisplayObjectContainer;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextConfig;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;

	public class ContextViewListenerConfig implements IContextConfig
	{

		[Inject]
		public var contextView:DisplayObjectContainer;

		[Inject]
		public var viewManager:IViewManager;

		public function configure(context:IContext):void
		{
			if (contextView)
			{
				context.logger.info(this, 'Adding contextView to viewManager. Note: avoid this where performance is critical.');
				viewManager.addContainer(contextView);
			}
			else
			{
				context.logger.warn(this, 'ContextViewListenerConfig was installed, but the contextView is null. Consider removing this config.');
			}
		}

		public function toString():String
		{
			return 'ContextViewListenerConfig';
		}
	}
}
