//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap
{
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMapTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTriggerTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class EventCommandMapExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var eventCommandMapExtension:EventCommandMapExtensionTest;

		public var eventCommandMap:EventCommandMapTest;

		public var eventCommandTrigger:EventCommandTriggerTest;

	}
}
