//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.extensions.viewManager.impl.StageWatcher_BasicTests;
	import org.robotlegs.v2.extensions.viewManager.impl.StageWatcher_BlockingTests;
	import org.robotlegs.v2.extensions.viewManager.impl.StageWatcher_OptimisationTests;
	import org.robotlegs.v2.extensions.viewManager.impl.StageWatcher_TimingTests;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class StageWatcherTestSuite
	{

		public var stageWatcherBasicTests:StageWatcher_BasicTests;

		public var stageWatcherBlockingTests:StageWatcher_BlockingTests;

		public var stageWatcherOptimisationTests:StageWatcher_OptimisationTests;

		public var stageWatcherTimingTests:StageWatcher_TimingTests;
	}
}
