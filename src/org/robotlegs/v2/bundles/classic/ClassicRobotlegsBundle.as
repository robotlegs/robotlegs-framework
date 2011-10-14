//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.classic
{
	import org.robotlegs.v2.bundles.shared.configs.AutoDestroyConfig;
	import org.robotlegs.v2.bundles.shared.configs.ContextViewWatcherConfig;
	import org.robotlegs.v2.bundles.shared.configs.SimpleTraceLoggingConfig;
	import org.robotlegs.v2.bundles.shared.utilities.LoggingEventDispatcher;
	import org.robotlegs.v2.core.api.IContextBuilder;
	import org.robotlegs.v2.core.api.IContextBuilderBundle;
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
			builder.withConfig(new SimpleTraceLoggingConfig());

			// Use a LoggingEventDispatcher
			builder.withDispatcher(new LoggingEventDispatcher());

			// note: interesting that I say "use" above instead of "with"

			// Install the ViewManager and StageWatcher extensions
			// and add the contextView to the ViewManager
			builder
				.withExtension(new StageWatcherExtension())
				.withExtension(new ViewManagerExtension())
				.withConfig(new ContextViewWatcherConfig());

			builder.withConfig(new AutoDestroyConfig());
		}
	}
}
