//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework
{
	import robotlegs.bender.framework.impl.MessageDispatcherStressTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class FrameworkStressTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var messageDispatcher:MessageDispatcherStressTest;
	}
}
