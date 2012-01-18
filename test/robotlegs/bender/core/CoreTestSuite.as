//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core
{
	import robotlegs.bender.core.async.AsyncTestSuite;
	import robotlegs.bender.core.message.MessageTestSuite;
	import robotlegs.bender.core.object.ObjectTestSuite;
	import robotlegs.bender.core.state.StateTestSuite;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class CoreTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var async:AsyncTestSuite;

		public var message:MessageTestSuite;

		public var object:ObjectTestSuite;

		public var state:StateTestSuite;
	}
}
