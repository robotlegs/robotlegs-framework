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
	import org.robotlegs.v2.extensions.viewManager.ViewManagerExtension;
	import org.robotlegs.v2.extensions.logging.SimpleLoggingExtension;

	public class ClassicRobotlegsBundle implements IContextBuilderBundle
	{

		public function install(builder:IContextBuilder):void
		{
			// Use a simple trace logger
			builder.withExtension(SimpleLoggingExtension);

			// Determine context hierarchy by way of contextView
			builder.withPreProcessor(ParentContextFinder);

			// Use a LoggingEventDispatcher
			builder.withDispatcher(new LoggingEventDispatcher());

			// Install the DisplayList extension
			// and add the contextView to the ViewManager
			builder
				.withExtension(ViewManagerExtension)
				.withConfig(ContextViewWatcherConfig);

			// Destroy the context when the contextView leaves the stage
			builder.withExtension(AutoDestroyExtension);
		}
	}
}
