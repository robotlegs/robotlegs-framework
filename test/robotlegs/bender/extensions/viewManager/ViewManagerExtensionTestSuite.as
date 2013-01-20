//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import robotlegs.bender.extensions.viewManager.impl.ConfigureViewObserverTest;
	import robotlegs.bender.extensions.viewManager.impl.ContainerBindingTest;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistryTest;
	import robotlegs.bender.extensions.viewManager.impl.StageCrawlerTest;
	import robotlegs.bender.extensions.viewManager.impl.StageObserverTest;
	import robotlegs.bender.extensions.viewManager.impl.ViewManagerTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ViewManagerExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var viewManagerExtension:ViewManagerExtensionTest;

		public var configureViewObserver:ConfigureViewObserverTest;

		public var containerBinding:ContainerBindingTest;

		public var containerRegistry:ContainerRegistryTest;

		public var stageObserver:StageObserverTest;

		public var stageCrawler:StageCrawlerTest;

		public var viewManager:ViewManagerTest;
	}
}
