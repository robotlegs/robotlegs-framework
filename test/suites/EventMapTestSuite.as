//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package suites
{
	import robotlegs.bender.extensions.eventMap.impl.EventMapTest;
	import robotlegs.bender.extensions.eventMap.impl.EventMapConfigTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class EventMapTestSuite
	{

		public var eventMapTest:EventMapTest;

		public var eventMapConfigTest:EventMapConfigTest;
	}
}