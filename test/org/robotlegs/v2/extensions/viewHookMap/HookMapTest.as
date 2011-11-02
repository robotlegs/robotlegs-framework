//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewHookMap
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.describeType;
	import org.flexunit.asserts.*;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.support.GrumpyGuard;
	import org.robotlegs.v2.extensions.guardsAndHooks.support.HappyGuard;
	import org.robotlegs.v2.extensions.guardsAndHooks.support.*
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessor;

	public class HookMapTest
	{

		private var hookTracker:HookTracker;

		private var injector:Injector;

		private var instance:HookMap;

		[Before]
		public function setUp():void
		{
			instance = new HookMap();
			injector = new Injector();
			hookTracker = new HookTracker();
			instance.injector = injector;
			instance.reflector = new DescribeTypeJSONReflector();
			instance.hooksProcessor = new HooksProcessor();
			instance.guardsProcessor = new GuardsProcessor();
			injector.map(HookTracker).toValue(hookTracker);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			injector = null;
		}

		[Test]
		public function a_grumpy_guard_prevents_the_hook_from_running():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).withHooks(TrackableHook1, TrackableHook2).withGuards(HappyGuard, GrumpyGuard);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder('no hooks run when guards prevent it', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function a_hook_is_run_after_mapping_with_injections():void
		{
			instance.map(ExampleTarget).withHooks(TrackableHook1);
			instance.process(new ExampleTarget());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1'];
			assertEqualsVectorsIgnoringOrder('hook ran in response to trigger class', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function a_hook_not_run_after_mapping_if_the_item_is_a_subclass():void
		{
			instance.map(DisplayObject).withHooks(TrackableHook1);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function all_happy_guards_allow_the_hook_to_run():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).withHooks(TrackableHook1, TrackableHook2).withGuards(HappyGuard);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run when the guards approved of it', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is HookMap", instance is HookMap);
		}

		[Test]
		public function multiple_hooks_run_after_mapping():void
		{
			instance.map(ExampleTarget).withHooks(TrackableHook1, TrackableHook2);
			instance.process(new ExampleTarget());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run in response to trigger class', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function no_hooks_run_for_unmatched_object():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).withHooks(TrackableHook1, TrackableHook2);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder('no hooks run for unmatched object', expectedHooksConfirmed, hookTracker.hooksConfirmed);

		}

		[Test]
		public function returns_false_if_not_interested_even_if_no_guards():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).withHooks(TrackableHook1, TrackableHook2);
			assertFalse(instance.process(new Sprite()));
		}

		[Test]
		public function returns_true_if_interested_even_if_guards_block_running():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).withHooks(TrackableHook1, TrackableHook2).withGuards(HappyGuard, GrumpyGuard);
			assertTrue(instance.process(new Sprite()));
		}

		[Test]
		public function runs_hooks_against_matched_matcher():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).withHooks(TrackableHook1, TrackableHook2);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run in response to class matching the matcher', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		// unmapping_the_hook_prevents_it_from_running
		// overmapping behaviour
	}
}

class ExampleTarget
{

	public function ExampleTarget()
	{
	}
}