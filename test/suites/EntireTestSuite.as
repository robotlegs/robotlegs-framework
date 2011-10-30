//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class EntireTestSuite
	{

		public var commandMapTestSuite:CommandMapTestSuite;

		public var contextBuilderTestSuite:ContextBuilderTestSuite;

		public var contextTestSuite:ContextTestSuite;

		public var hooksTestSuite:GuardsAndHooksTestSuite;

		public var mediatorMapTestSuite:MediatorMapTestSuite;

		public var stageWatcherTestSuite:StageWatcherTestSuite;

		public var typeMatchingTestSuite:TypeMatchingTestSuite;
	}
}
