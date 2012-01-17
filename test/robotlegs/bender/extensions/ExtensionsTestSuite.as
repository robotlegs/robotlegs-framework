//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions
{
	import robotlegs.bender.extensions.commandMap.impl.CommandMapTest;
	import robotlegs.bender.extensions.contextView.ContextViewExtensionTest;
	import robotlegs.bender.extensions.eventBus.EventBusExtensionTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMapTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTriggerTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger_GuardTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger_HookTest;
	import robotlegs.bender.extensions.localEventMap.impl.EventMapConfigTest;
	import robotlegs.bender.extensions.localEventMap.impl.EventMapTest;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapTestSuite;
	import robotlegs.bender.extensions.modularity.ModularityExtensionTest;
	import robotlegs.bender.extensions.stageSync.StageSyncExtensionTest;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtensionTest;
	import robotlegs.bender.extensions.viewManager.impl.ContainerBindingTest;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistryTest;
	import robotlegs.bender.extensions.viewManager.impl.StageObserverTest;
	import robotlegs.bender.extensions.viewManager.impl.ViewManagerTest;

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

		public var eventCommandMapTrigger:EventCommandTriggerTest;

		public var eventCommandMapTrigger_Guard:EventCommandTrigger_GuardTest;

		public var eventCommandMapTrigger_Hook:EventCommandTrigger_HookTest;

		public var modularity:ModularityExtensionTest;

		public var eventMap:EventMapTest;

		public var eventMapConfig:EventMapConfigTest;

		public var containerBinding:ContainerBindingTest;

		public var containerRegistry:ContainerRegistryTest;

		public var stageObserver:StageObserverTest;

		public var viewManager:ViewManagerTest;

		public var viewManagerExtension:ViewManagerExtensionTest;

		public var mediatorMapTestSuite:MediatorMapTestSuite;
	}
}
