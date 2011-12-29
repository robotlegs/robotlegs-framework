//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.classic
{
	import robotlegs.bender.bundles.shared.configs.ContextViewListenerConfig;
	import robotlegs.bender.core.api.ContextLogLevel;
	import robotlegs.bender.core.api.IContextBuilder;
	import robotlegs.bender.core.api.IContextBuilderBundle;
	import robotlegs.bender.extensions.autoDestroy.AutoDestroyExtension;
	import robotlegs.bender.extensions.commandMap.CommandMapExtension;
	import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtension;
	import robotlegs.bender.extensions.logging.impl.TraceLogTarget;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
	import robotlegs.bender.extensions.modularity.ModularityExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;

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
