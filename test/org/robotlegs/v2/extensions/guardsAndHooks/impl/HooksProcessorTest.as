//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guardsAndHooks.impl
{
	import org.flexunit.asserts.*;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.robotlegs.v2.extensions.guardsAndHooks.support.*;
	import org.robotlegs.v2.extensions.guardsAndHooks.support.HookTracker;
	import org.swiftsuspenders.Injector;

	public class HooksProcessorTest
	{

		private var hookTracker:HookTracker;

		private var injector:Injector;

		private var instance:HooksProcessor;

		[Before]
		public function setUp():void
		{
			instance = new HooksProcessor();
			injector = new Injector();
			hookTracker = new HookTracker();
			injector.map(HookTracker).toValue(hookTracker);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			injector = null;
		}

		[Test(expects='ArgumentError')]
		public function a_non_hook_causes_us_to_throw_an_argument_error():void
		{
			var requiredHooks:Vector.<Class> = new <Class>[TrackableHook1, TrackableHook2, NonHook];
			instance.runHooks(injector, requiredHooks);
		}

		[Test]
		public function a_number_of_hooks_are_run():void
		{
			var requiredHooks:Vector.<Class> = new <Class>[TrackableHook1, TrackableHook2];
			instance.runHooks(injector, requiredHooks);

			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is HooksProcessor", instance is HooksProcessor);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
	}
}
