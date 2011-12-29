//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.hooks.impl
{
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.hooks.api.IHookGroup;
	import robotlegs.bender.extensions.hooks.support.CallbackHook;
	import robotlegs.bender.extensions.hooks.support.HookTracker;
	import robotlegs.bender.extensions.hooks.support.NonHook;
	import robotlegs.bender.extensions.hooks.support.NullHook;
	import robotlegs.bender.extensions.hooks.support.TrackableHook1;
	import robotlegs.bender.extensions.hooks.support.TrackableHook2;
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
		}

		[Test]
		public function hooks_should_all_run():void
		{
			hooks.add(TrackableHook1, TrackableHook2);
			hooks.hook();
			const expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function removed_hook_should_not_run():void
		{
			var hookCallCount:uint;
			injector.map(Function, "hookCallback").toValue(function():void
			{
				hookCallCount++
			});
			hooks.add(NullHook, CallbackHook);
			hooks.remove(CallbackHook);
			hooks.hook();
			assertThat(hookCallCount, equalTo(0));
		}

	}
}
