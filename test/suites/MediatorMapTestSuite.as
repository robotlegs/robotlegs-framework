//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.extensions.mediatorMap.MediatorMapTest;
	import org.robotlegs.v2.utilities.mediatorTriggers.DuckTypedMediatorTriggerTest;
	import org.robotlegs.v2.utilities.mediatorTriggers.RL2MediatorTriggerTest;
	import org.robotlegs.v2.utilities.mediatorTriggers.RL1MediatorTriggerTest;
	import org.robotlegs.v2.extensions.mediatorMap.MediatorMapRemovalAndReparentingTests;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class MediatorMapTestSuite extends Object
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var mediatorMapTest:MediatorMapTest;
		
		public var duckTypedMediatorTriggerTest:DuckTypedMediatorTriggerTest;
		
		public var rl2MediatorTriggerTest:RL2MediatorTriggerTest;
		
		public var rl1MediatorTriggerTest:RL1MediatorTriggerTest;
		
		public var mediatorReparentingTests:MediatorMapRemovalAndReparentingTests;

		// Don't uncomment this - the test is only in the code base for
		// reference while we match behaviour.
		//public var mediatorMapV1FunctionalityTest:MediatorMapV1Test;
	}
}