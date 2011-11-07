//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks.impl
{
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.robotlegs.v2.extensions.hooks.support.HookTracker;
	import org.robotlegs.v2.extensions.hooks.support.NonHook;
	import org.robotlegs.v2.extensions.hooks.support.TrackableHook1;
	import org.robotlegs.v2.extensions.hooks.support.TrackableHook2;
	import org.robotlegs.v2.extensions.hooks.api.IHookGroup;
	import org.swiftsuspenders.Injector;

	public class HookGroupTests
	{
		private var hookTracker:HookTracker;

		private var injector:Injector;

		private var hooks:IHookGroup;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			hooks = new HookGroup(injector);
			hookTracker = new HookTracker();
			injector.map(HookTracker).toValue(hookTracker);
		}

		[After]
		public function tearDown():void
		{
			hooks = null;
			injector = null;
			hookTracker = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertThat(hooks, instanceOf(IHookGroup));
		}

		[Test(expects='ArgumentError')]
		public function a_non_hook_causes_us_to_throw_an_argument_error():void
		{
			hooks.add(TrackableHook1, TrackableHook2, NonHook);
			hooks.hook();
		}

		[Test]
		public function hooks_should_all_run():void
		{
			hooks.add(TrackableHook1, TrackableHook2);
			hooks.hook();
			const expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
	}
}
