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

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var commandMapTestSuite:CommandMapTestSuite;

		public var eventCommandMapTestSuite:EventCommandMapTestSuite;

		public var viewManagerTestSuite:ViewManagerTestSuite;

		public var eventMapTestSuite:EventMapTestSuite;

		public var guardsTestSuite:GuardsTestSuite;

		public var hooksTestSuite:HooksTestSuite;
	}
}
