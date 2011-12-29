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
	import robotlegs.bender.extensions.mediatorMap.configs.RL1MediatorsStrictConfig;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
	import robotlegs.bender.extensions.viewManager.AutoStageListenerExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;

	public class RL1MediatorsMediatorMapBundle implements IContextBuilderBundle
	{
		public function install(builder:IContextBuilder):void
		{
			builder
				.withExtension(ViewManagerExtension)
				.withExtension(AutoStageListenerExtension)
				.withExtension(MediatorMapExtension)
				.withConfig(RL1MediatorsStrictConfig)
				.withConfig(ContextViewListenerConfig);
		}
	}
}