//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core
{
	import robotlegs.bender.core.async.AsyncTestSuite;
	import robotlegs.bender.core.messaging.MessageDispatcherTestSuite;
	import robotlegs.bender.core.objectProcessor.ObjectProcessorTestSuite;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class CoreTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var async:AsyncTestSuite;

		public var message:MessageDispatcherTestSuite;

		public var object:ObjectProcessorTestSuite;
	}
}