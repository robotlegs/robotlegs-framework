//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.classic
{
	import org.robotlegs.v2.bundles.shared.configs.ContextViewWatcherConfig;
	import org.robotlegs.v2.bundles.shared.processors.ParentContextFinder;
	import org.robotlegs.v2.bundles.shared.utilities.LoggingEventDispatcher;
	import org.robotlegs.v2.core.api.IContextBuilder;
	import org.robotlegs.v2.core.api.IContextBuilderBundle;
	import org.robotlegs.v2.extensions.autoDestroy.AutoDestroyExtension;
	import org.robotlegs.v2.extensions.logging.SimpleLoggingExtension;
	import org.robotlegs.v2.extensions.stageWatcher.StageWatcherExtension;
	import org.robotlegs.v2.extensions.viewManager.ViewManagerExtension;

	public class ClassicRobotlegsBundle implements IContextBuilderBundle
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function install(builder:IContextBuilder):void
		{
			// Use a simple trace logger
			builder.withExtension(new SimpleLoggingExtension());

			// Use a LoggingEventDispatcher
			builder.withDispatcher(new LoggingEventDispatcher());

			// note: interesting that I say "use" above instead of "with"

			// Install the ViewManager and StageWatcher extensions
			// and add the contextView to the ViewManager
			builder
				.withExtension(new ViewManagerExtension())
				.withExtension(new StageWatcherExtension())
				.withConfig(new ContextViewWatcherConfig());

			// Determine context hierarchy by way of contextView
			builder.withProcessor(new ParentContextFinder());

			// Destroy the context when the contextView leaves the stage
			builder.withExtension(new AutoDestroyExtension());
		}
	}
}
