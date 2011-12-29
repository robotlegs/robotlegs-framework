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
	import robotlegs.bender.extensions.eventMap.EventMapExtension;
	import robotlegs.bender.extensions.logging.impl.TraceLogTarget;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;
	import robotlegs.bender.extensions.mediatorMap.configs.RL2MediatorsConfig;
	import robotlegs.bender.extensions.modularity.ModularityExtension;
	import robotlegs.bender.extensions.viewManager.AutoStageListenerExtension;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;

	public class ClassicRobotlegsBundle implements IContextBuilderBundle
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

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

			// Install the LocalEventMap extension
			builder.withExtension(EventMapExtension);

			// Install the ViewManager extension
			// and the AutoStageListener extension
			// and add the contextView to the ViewManager
			builder
				.withExtension(ViewManagerExtension)
				.withExtension(AutoStageListenerExtension)
				.withConfig(ContextViewListenerConfig);

			// Install the MediatorMap extension
			// and configure for RL2 mediation
			builder
				.withExtension(MediatorMapExtension)
				.withConfig(RL2MediatorsConfig);

			// Destroy the context when the contextView leaves the stage
			builder.withExtension(AutoDestroyExtension);
		}
	}
}
