package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import org.robotlegs.v2.core.impl.TypeFilterTest;
	import org.robotlegs.v2.core.impl.TypeFilterUsageTest;
	import org.robotlegs.v2.core.impl.TypeMatcherTest;
	import org.robotlegs.v2.core.utilities.RunningInFlexUtilFunctionTest;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMapTest;
	import org.robotlegs.v2.extensions.eventMap.impl.EventMapTest;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessorTest;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessorTest;
	import org.robotlegs.v2.extensions.mediatorMap.configs.RL2MediatorsConfigTest;
	import org.robotlegs.v2.extensions.mediatorMap.impl.MediatorTest;
	import org.robotlegs.v2.extensions.mediatorMap.MediatorMapExtensionTest;
	import org.robotlegs.v2.extensions.mediatorMap.MediatorMapTest;
	import org.robotlegs.v2.extensions.mediatorMap.MediatorMapV1Test;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger_strategiesTest;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTriggerTest;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTrigger_strategiesTest;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTriggerTest;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1MediatorTriggerTest;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger_strategiesTest;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL2MediatorTriggerTest;
	import org.robotlegs.v2.extensions.viewHookMap.HookMapTest;
	import org.robotlegs.v2.extensions.viewHookMap.ViewHookMapTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new org.robotlegs.v2.core.impl.TypeFilterTest());
			addTest(new org.robotlegs.v2.core.impl.TypeFilterUsageTest());
			addTest(new org.robotlegs.v2.core.impl.TypeMatcherTest());
			addTest(new org.robotlegs.v2.core.utilities.RunningInFlexUtilFunctionTest());
			addTest(new org.robotlegs.v2.extensions.eventMap.api.IEventMapTest());
			addTest(new org.robotlegs.v2.extensions.eventMap.impl.EventMapTest());
			addTest(new org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessorTest());
			addTest(new org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessorTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.configs.RL2MediatorsConfigTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.impl.MediatorTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.MediatorMapExtensionTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.MediatorMapTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.MediatorMapV1Test());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger_strategiesTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTriggerTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTrigger_strategiesTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTriggerTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1MediatorTriggerTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger_strategiesTest());
			addTest(new org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL2MediatorTriggerTest());
			addTest(new org.robotlegs.v2.extensions.viewHookMap.HookMapTest());
			addTest(new org.robotlegs.v2.extensions.viewHookMap.ViewHookMapTest());
		}
	}
}
