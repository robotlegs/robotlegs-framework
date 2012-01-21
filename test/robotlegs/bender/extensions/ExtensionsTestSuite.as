//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions
{
	import robotlegs.bender.extensions.commandMap.CommandMapExtensionTestSuite;
	import robotlegs.bender.extensions.contextView.ContextViewExtensionTestSuite;
	import robotlegs.bender.extensions.eventCommandMap.EventCommandMapExtensionTestSuite;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtensionTestSuite;
	import robotlegs.bender.extensions.localEventMap.LocalEventMapExtensionTestSuite;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtensionTestSuite;
	import robotlegs.bender.extensions.messageCommandMap.MessageCommandMapExtensionTestSuite;
	import robotlegs.bender.extensions.modularity.ModularityExtensionTestSuite;
	import robotlegs.bender.extensions.stageSync.StageSyncExtensionTestSuite;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtensionTestSuite;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ExtensionsTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var commandMapExtension:CommandMapExtensionTestSuite;

		public var contextViewExtension:ContextViewExtensionTestSuite;

		public var eventCommandMapExtension:EventCommandMapExtensionTestSuite;

		public var eventDispatcherExtension:EventDispatcherExtensionTestSuite;

		public var localEventMapExtension:LocalEventMapExtensionTestSuite;

		public var mediatorMapExtension:MediatorMapExtensionTestSuite;

		public var messageCommandMapExtension:MessageCommandMapExtensionTestSuite;

		public var modularityExtension:ModularityExtensionTestSuite;

		public var stageSyncExtension:StageSyncExtensionTestSuite;

		public var viewManagerExtension:ViewManagerExtensionTestSuite;
	}
}
