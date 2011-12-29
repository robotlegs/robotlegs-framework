//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package suites
{
	import robotlegs.bender.extensions.viewManager.impl.ViewManager_BasicTests;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager_BlockingTests;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager_OptimisationTests;
	import robotlegs.bender.extensions.viewManager.impl.ViewManager_TimingTests;
	import robotlegs.bender.extensions.viewManager.impl.ContainerBindingTest;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistryTest;
	import robotlegs.bender.extensions.viewManager.impl.ViewClassInfoTest;
	import robotlegs.bender.extensions.viewManager.api.ViewInterestsTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ViewManagerTestSuite
	{

		public var viewManagerBasicTests:ViewManager_BasicTests;

		public var viewManagerBlockingTests:ViewManager_BlockingTests;

		public var viewManagerOptimisationTests:ViewManager_OptimisationTests;

		public var viewManagerTimingTests:ViewManager_TimingTests;

		public var containerBindingTest:ContainerBindingTest;

		public var containerRegistryTest:ContainerRegistryTest;

		public var viewClassInfoTest:ViewClassInfoTest;

		public var viewInterestsTest:ViewInterestsTest;
	}
}