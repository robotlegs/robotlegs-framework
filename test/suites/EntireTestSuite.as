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

		public var eventCommandMapTestSuite:EventCommandMapTestSuite;

		public var contextBuilderTestSuite:ContextBuilderTestSuite;

		public var contextTestSuite:ContextTestSuite;

		public var typeMatchingTestSuite:TypeMatchingTestSuite;

		public var utilityPackageTestSuite:UtilityPackageFunctionsSuite;

		public var mediatorMapTestSuite:MediatorMapTestSuite;
		
		public var viewMapTestSuite:ViewMapTestSuite;

		public var viewManagerTestSuite:ViewManagerTestSuite;

		public var eventMapTestSuite:EventMapTestSuite;

		public var commandFlowTestSuite:CommandFlowTestSuite;

		public var guardsTestSuite:GuardsTestSuite;

		public var hooksTestSuite:HooksTestSuite;
		
		public var loggingTestSuite:LoggingTestSuite;

		public var viewInjectionMapTestSuite:ViewInjectionMapTestSuite;
	}
}