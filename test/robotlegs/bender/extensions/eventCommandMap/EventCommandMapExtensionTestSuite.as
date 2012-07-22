//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap
{
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMapTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTriggerTest;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandExecutorTest;

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
		
		public var eventCommandExecutor:EventCommandExecutorTest;
	}
}