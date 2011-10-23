//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.core.impl.TypeMatcherTest;
	import org.robotlegs.v2.core.impl.TypeFilterTest;
	import org.robotlegs.v2.core.impl.TypeFilterUsageTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class TypeMatchingTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var typeMatcherTest:TypeMatcherTest;
		public var typeFilterTest:TypeFilterTest;
		public var typeFilterUsageTest:TypeFilterUsageTest;
	}
}