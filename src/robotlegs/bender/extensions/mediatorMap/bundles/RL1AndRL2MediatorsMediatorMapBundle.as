//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.bundles
{
	import robotlegs.bender.bundles.shared.configs.ContextViewListenerConfig;
	import robotlegs.bender.core.api.IContextBuilder;
	import robotlegs.bender.core.api.IContextBuilderBundle;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
	import robotlegs.bender.extensions.viewManager.AutoStageListenerExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.extensions.mediatorMap.configs.RL1AndRL2MediatorsStrictConfig;

	public class RL1AndRL2MediatorsMediatorMapBundle implements IContextBuilderBundle
	{
		public function install(builder:IContextBuilder):void
		{
			builder
				.withExtension(ViewManagerExtension)
				.withExtension(AutoStageListenerExtension)
				.withExtension(MediatorMapExtension)
				.withConfig(RL1AndRL2MediatorsStrictConfig)
				.withConfig(ContextViewListenerConfig);
		}
	}
}