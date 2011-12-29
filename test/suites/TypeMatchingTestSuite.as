//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package suites
{
	import robotlegs.bender.core.impl.TypeFilterTest;
	import robotlegs.bender.core.impl.TypeFilterUsageTest;
	import robotlegs.bender.core.impl.TypeMatcherTest;
	import robotlegs.bender.core.impl.PackageFilter_descriptorTest;
	import robotlegs.bender.core.impl.PackageMatchingTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class TypeMatchingTestSuite
	{

		public var typeFilterTest:TypeFilterTest;

		public var typeFilterUsageTest:TypeFilterUsageTest;

		public var typeMatcherTest:TypeMatcherTest;

		public var packageMatcherTest:PackageMatchingTest;

		public var packageFilter_descriptorTest:PackageFilter_descriptorTest;
	}
}