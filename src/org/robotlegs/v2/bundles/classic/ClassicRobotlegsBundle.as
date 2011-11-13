//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.classic
{
	import org.robotlegs.v2.bundles.shared.configs.ContextViewListenerConfig;
	import org.robotlegs.v2.core.api.ContextLogLevel;
	import org.robotlegs.v2.core.api.IContextBuilder;
	import org.robotlegs.v2.core.api.IContextBuilderBundle;
	import org.robotlegs.v2.extensions.autoDestroy.AutoDestroyExtension;
	import org.robotlegs.v2.extensions.commandMap.CommandMapExtension;
	import org.robotlegs.v2.extensions.eventCommandMap.EventCommandMapExtension;
	import org.robotlegs.v2.extensions.logging.impl.TraceLogTarget;
	import org.robotlegs.v2.extensions.mediatorMap.MediatorMapExtension;
	import org.robotlegs.v2.extensions.modularity.ModularityExtension;
	import org.robotlegs.v2.extensions.viewManager.ViewManagerExtension;

	public class ClassicRobotlegsBundle implements IContextBuilderBundle
	{

		public function install(builder:IContextBuilder):void
		{
			// Use a simple trace logger
			builder.withLogTarget(new TraceLogTarget(ContextLogLevel.DEBUG));

			// Install the Modularity extension
			builder.withExtension(ModularityExtension);

			// Install the CommandMap extension
			builder.withExtension(CommandMapExtension);

			// Install the EventCommandMap extension
			builder.withExtension(EventCommandMapExtension);

			// Install the DisplayList extension
			// and add the contextView to the ViewManager
			builder
				.withExtension(ViewManagerExtension)
				.withConfig(ContextViewListenerConfig);

			// Install the MediatorMap extension
			builder.withExtension(MediatorMapExtension);

			// Destroy the context when the contextView leaves the stage
			builder.withExtension(AutoDestroyExtension);
		}
	}
}
