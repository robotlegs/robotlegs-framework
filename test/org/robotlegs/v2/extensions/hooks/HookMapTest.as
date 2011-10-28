//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks 
{
	import org.flexunit.asserts.*;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.swiftsuspenders.Injector;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import org.robotlegs.v2.extensions.guards.support.HappyGuard;
	import org.robotlegs.v2.extensions.guards.support.GrumpyGuard;
	import org.robotlegs.v2.extensions.hooks.support.*

	public class HookMapTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:HookMap;
		private var injector:Injector;
		private var hookTracker:HookTracker;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new HookMap();
			injector = new Injector();
			hookTracker = new HookTracker();
			instance.injector = injector;
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

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is HookMap", instance is HookMap);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function a_hook_is_run_after_mapping_with_injections():void
		{
			instance.map(ExampleTarget).toHook(TrackableHook1);
			instance.process(new ExampleTarget());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1'];
			assertEqualsVectorsIgnoringOrder('hook ran in response to trigger class', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function multiple_hooks_run_after_mapping():void
		{
			instance.map(ExampleTarget).toHooks(TrackableHook1, TrackableHook2);
			instance.process(new ExampleTarget());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run in response to trigger class', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function runs_hooks_against_matched_matcher():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toHooks(TrackableHook1, TrackableHook2);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run in response to class matching the matcher', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function no_hooks_run_for_unmatched_object():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).toHooks(TrackableHook1, TrackableHook2);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder('no hooks run for unmatched object', expectedHooksConfirmed, hookTracker.hooksConfirmed);
			
		}
		
		[Test]
		public function a_grumpy_guard_prevents_the_hook_from_running():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toHooks(TrackableHook1, TrackableHook2).withGuards(HappyGuard, GrumpyGuard);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder('no hooks run when guards prevent it', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function all_happy_guards_allow_the_hook_to_run():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toHooks(TrackableHook1, TrackableHook2).withGuards(HappyGuard);
			instance.process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run when the guards approved of it', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function returns_true_if_interested_even_if_guards_block_running():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toHooks(TrackableHook1, TrackableHook2).withGuards(HappyGuard, GrumpyGuard);
			assertTrue( instance.process(new Sprite()));			
		}

		[Test]
		public function returns_false_if_not_interested_even_if_no_guards():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).toHooks(TrackableHook1, TrackableHook2);
			assertFalse(instance.process(new Sprite()));
		}
		
		// unmapping_the_hook_prevents_it_from_running

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}

class ExampleTarget
{
	public function ExampleTarget()
	{
	}
}