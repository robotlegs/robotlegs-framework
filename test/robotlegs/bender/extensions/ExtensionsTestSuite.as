//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions
{
	import robotlegs.bender.extensions.commandMap.impl.CommandMapTest;
	import robotlegs.bender.extensions.displayList.ContextViewExtensionTest;
	import robotlegs.bender.extensions.displayList.StageSyncExtensionTest;
	import robotlegs.bender.extensions.eventBus.EventBusExtensionTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMapTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger_BasicTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger_GuardTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger_HookTest;
	import robotlegs.bender.extensions.eventMap.impl.EventMapConfigTest;
	import robotlegs.bender.extensions.eventMap.impl.EventMapTest;
	import robotlegs.bender.extensions.modularity.ModularityExtensionTest;
	import robotlegs.bender.extensions.viewManager.api.ViewInterestsTest;
	import robotlegs.bender.extensions.viewManager.impl.ContainerBindingTest;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistryTest;
	import robotlegs.bender.extensions.viewManager.impl.ViewClassInfoTest;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager_BasicTest;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager_BlockingTest;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager_OptimisationTest;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager_TimingTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ExtensionsTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var commandMap:CommandMapTest;

		public var contextView:ContextViewExtensionTest;

		public var stateSync:StageSyncExtensionTest;

		public var eventBus:EventBusExtensionTest;

		public var eventCommandMap:EventCommandMapTest;

		public var eventCommandMapTrigger_Basic:EventCommandTrigger_BasicTest;

		public var eventCommandMapTrigger_Guard:EventCommandTrigger_GuardTest;

		public var eventCommandMapTrigger_Hook:EventCommandTrigger_HookTest;

		public var modularity:ModularityExtensionTest;

		public var eventMap:EventMapTest;

		public var eventMapConfig:EventMapConfigTest;

		// view manager is old, will be re-designed

		public var viewInteterest:ViewInterestsTest;

		public var containerBinding:ContainerBindingTest;

		public var containerRegistry:ContainerRegistryTest;

		public var viewClassInfo:ViewClassInfoTest;

		public var viewManager_Basic:ViewManager_BasicTest;

		public var viewManager_Blocking:ViewManager_BlockingTest;

		public var viewManager_Optimisation:ViewManager_OptimisationTest;

		public var viewManager_Timing:ViewManager_TimingTest;
	}
}
