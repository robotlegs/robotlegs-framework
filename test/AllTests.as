package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import robotlegs.bender.core.impl.TypeFilterTest;
	import robotlegs.bender.core.impl.TypeFilterUsageTest;
	import robotlegs.bender.core.impl.TypeMatcherTest;
	import robotlegs.bender.core.utilities.RunningInFlexUtilFunctionTest;
	import robotlegs.bender.extensions.eventMap.api.IEventMapTest;
	import robotlegs.bender.extensions.eventMap.impl.EventMapTest;
	import robotlegs.bender.extensions.guardsAndHooks.impl.GuardsProcessorTest;
	import robotlegs.bender.extensions.guardsAndHooks.impl.HooksProcessorTest;
	import robotlegs.bender.extensions.mediatorMap.configs.RL2MediatorsConfigTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorTest;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapExtensionTest;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapTest;
	import robotlegs.bender.extensions.mediatorMap.MediatorMapV1Test;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger_strategiesTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTriggerTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTrigger_strategiesTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTriggerTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1MediatorTriggerTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger_strategiesTest;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL2MediatorTriggerTest;
	import robotlegs.bender.extensions.viewHookMap.HookMapTest;
	import robotlegs.bender.extensions.viewHookMap.ViewHookMapTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new robotlegs.bender.core.impl.TypeFilterTest());
			addTest(new robotlegs.bender.core.impl.TypeFilterUsageTest());
			addTest(new robotlegs.bender.core.impl.TypeMatcherTest());
			addTest(new robotlegs.bender.core.utilities.RunningInFlexUtilFunctionTest());
			addTest(new robotlegs.bender.extensions.eventMap.api.IEventMapTest());
			addTest(new robotlegs.bender.extensions.eventMap.impl.EventMapTest());
			addTest(new robotlegs.bender.extensions.guardsAndHooks.impl.GuardsProcessorTest());
			addTest(new robotlegs.bender.extensions.guardsAndHooks.impl.HooksProcessorTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.configs.RL2MediatorsConfigTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.impl.MediatorTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.MediatorMapExtensionTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.MediatorMapTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.MediatorMapV1Test());
			addTest(new robotlegs.bender.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger_strategiesTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTriggerTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTrigger_strategiesTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTriggerTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1MediatorTriggerTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger_strategiesTest());
			addTest(new robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL2MediatorTriggerTest());
			addTest(new robotlegs.bender.extensions.viewHookMap.HookMapTest());
			addTest(new robotlegs.bender.extensions.viewHookMap.ViewHookMapTest());
		}
	}
}
