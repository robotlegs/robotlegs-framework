//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core
{
	import robotlegs.bender.core.async.SafelyCallBackTest;
	import robotlegs.bender.core.message.dispatcher.impl.MessageDispatcherTest;
	import robotlegs.bender.core.object.processor.impl.ObjectProcessorTest;
	import robotlegs.bender.core.object.processor.impl.TypeCachedObjectProcessorTest;
	import robotlegs.bender.core.state.machine.impl.StateMachineTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class CoreTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var async:SafelyCallBackTest;

		public var messageDispatcher:MessageDispatcherTest;

		public var stateMachine:StateMachineTest;

		public var objectProcessor:ObjectProcessorTest;

		public var typeCachedObjectProcessor:TypeCachedObjectProcessorTest;
	}
}
