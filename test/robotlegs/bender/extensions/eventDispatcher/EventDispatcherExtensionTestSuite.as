//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventDispatcher
{
	import robotlegs.bender.extensions.eventDispatcher.impl.EventRelayTest;
	import robotlegs.bender.extensions.eventDispatcher.impl.LifecycleEventRelayTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class EventDispatcherExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var eventDispatcherExtension:EventDispatcherExtensionTest;

		public var eventRelay:EventRelayTest;

		public var lifecycleEventRedispatcher:LifecycleEventRelayTest;
	}
}
