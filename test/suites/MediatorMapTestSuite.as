//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package suites
{
	import robotlegs.bender.extensions.mediatorMap.MediatorMapRemovalAndReparentingTests;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTriggerTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1MediatorTriggerTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL2MediatorTriggerTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger_strategiesTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger_strategiesTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTriggerTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTrigger_strategiesTest;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtensionTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorSugarTest;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapV1Test;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class MediatorMapTestSuite extends Object
	{
		public var mediatorMapTest:MediatorMapTest;

		public var mediatorReparentingTests:MediatorMapRemovalAndReparentingTests;

		public var mediatorTest:MediatorTest;

		public var duckTypedMediatorTriggerTest:DuckTypedMediatorTriggerTest;

		public var rl1MediatorTriggerTest:RL1MediatorTriggerTest;

		public var rl2MediatorTriggerTest:RL2MediatorTriggerTest;

		public var rl1AndRL2MediatorTriggerTest:RL1AndRL2MediatorTriggerTest;

		public var rl2MediatorTrigger_strategiesTest:RL2MediatorTrigger_strategiesTest;

		public var duckTypedMediatorTrigger_strategiesTest:DuckTypedMediatorTrigger_strategiesTest;

		public var rl1AndRL2MediatorTrigger_strategiesTest:RL1AndRL2MediatorTrigger_strategiesTest;

		public var mediatorMapExtensionTest:MediatorMapExtensionTest;

		public var mediatorSugarTest:MediatorSugarTest;

		public var mediatorMapV1FunctionalityTest:MediatorMapV1Test;
	}
}