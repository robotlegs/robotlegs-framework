//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions
{
	import robotlegs.bender.extensions.commandCenter.CommandCenterExtensionTestSuite;
	import robotlegs.bender.extensions.contextView.ContextViewExtensionTestSuite;
	import robotlegs.bender.extensions.directCommandMap.DirectCommandMapExtensionTestSuite;
	import robotlegs.bender.extensions.enhancedLogging.EnhancedLoggingExtensionTestSuite;
	import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtensionTestSuite;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtensionTestSuite;
	import robotlegs.bender.extensions.localEventMap.LocalEventMapExtensionTestSuite;
	import robotlegs.bender.extensions.matching.TypeMatchingTestSuite;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtensionTestSuite;
	import robotlegs.bender.extensions.modularity.ModularityExtensionTestSuite;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtensionTestSuite;
	import robotlegs.bender.extensions.viewProcessorMap.ViewProcessorMapExtensionTestSuite;
	import robotlegs.bender.extensions.vigilance.VigilanceExtensionTestSuite;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ExtensionsTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var commandMapExtension:CommandCenterExtensionTestSuite;

		public var directCommandMapExtension:DirectCommandMapExtensionTestSuite;

		public var contextViewExtension:ContextViewExtensionTestSuite;

		public var eventCommandMapExtension:EventCommandMapExtensionTestSuite;

		public var eventDispatcherExtension:EventDispatcherExtensionTestSuite;

		public var localEventMapExtension:LocalEventMapExtensionTestSuite;

		public var loggingExtension:EnhancedLoggingExtensionTestSuite;

		public var mediatorMapExtension:MediatorMapExtensionTestSuite;

		public var modularityExtension:ModularityExtensionTestSuite;

		public var viewManagerExtension:ViewManagerExtensionTestSuite;

		public var viewProcessorMapExtension:ViewProcessorMapExtensionTestSuite;

		public var vigilanceExtension:VigilanceExtensionTestSuite;

		public var matching:TypeMatchingTestSuite;
	}
}
