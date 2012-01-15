//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.hook.impl
{
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.hook.support.CallbackHook;
	import robotlegs.bender.framework.hook.support.HookTracker;
	import robotlegs.bender.framework.hook.support.NonHook;
	import robotlegs.bender.framework.hook.support.NullHook;
	import robotlegs.bender.framework.hook.support.TrackableHook1;
	import robotlegs.bender.framework.hook.support.TrackableHook2;
	import robotlegs.bender.framework.hook.api.IHookGroup;

	public class HookGroupTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var hookTracker:HookTracker;

		private var injector:Injector;

		private var hooks:IHookGroup;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

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

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

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
