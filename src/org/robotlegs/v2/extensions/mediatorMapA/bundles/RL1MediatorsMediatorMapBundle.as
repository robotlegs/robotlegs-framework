//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.bundles
{
	import org.robotlegs.v2.bundles.shared.configs.ContextViewListenerConfig;
	import org.robotlegs.v2.core.api.IContextBuilder;
	import org.robotlegs.v2.core.api.IContextBuilderBundle;
	import org.robotlegs.v2.extensions.mediatorMapA.configs.RL1MediatorsStrictConfig;
	import org.robotlegs.v2.extensions.mediatorMapA.MediatorMapExtension;
	import org.robotlegs.v2.extensions.viewManager.AutoStageListenerExtension;
	import org.robotlegs.v2.extensions.viewManager.ViewManagerExtension;

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