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
	import org.robotlegs.v2.extensions.mediatorMapA.MediatorMapExtension;
	import org.robotlegs.v2.extensions.viewManager.AutoStageListenerExtension;
	import org.robotlegs.v2.extensions.viewManager.ViewManagerExtension;
	import org.robotlegs.v2.extensions.mediatorMapA.configs.RL1AndRL2MediatorsStrictConfig;

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