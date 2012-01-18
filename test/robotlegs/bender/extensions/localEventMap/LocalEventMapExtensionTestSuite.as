//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap
{
	import robotlegs.bender.extensions.localEventMap.impl.EventMapConfigTest;
	import robotlegs.bender.extensions.localEventMap.impl.EventMapTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class LocalEventMapExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var localEventMapExtension:LocalEventMapExtensionTest;

		public var eventMap:EventMapTest;

		public var eventMapConfig:EventMapConfigTest;
	}
}
