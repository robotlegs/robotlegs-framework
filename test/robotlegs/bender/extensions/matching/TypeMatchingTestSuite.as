//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class TypeMatchingTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var typeFilterTest:TypeFilterTest;

		public var typeFilterUsageTest:TypeFilterUsageTest;

		public var typeMatcherTest:TypeMatcherTest;

		public var packageMatcherTest:PackageMatchingTest;

		public var packageFilter_descriptorTest:PackageFilter_descriptorTest;

		public var instanceOfTypeTest:InstanceOfTypeTest;
	}
}
