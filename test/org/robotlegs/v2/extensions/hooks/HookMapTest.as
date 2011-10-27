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

	public class HookMapTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:HookMap;
		private var injector:Injector;
		private const hookTracker:HookTracker = new HookTracker();

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new HookMap();
			injector = new Injector();
			instance.injector = injector;
			instance.hooksProcessor = new HooksProcessor();
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
		
		// always_returns_non_blocking_bitmask
		
		// returns_true_if_interested
		
		// returns_false_if_not_interested
		
		// unmapping_the_hook_prevents_it_from_running
		
		// a_grumpy_guard_prevents_the_hook_from_running
		
		// all_happy_guards_allow_the_hook_to_run

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}

class ExampleHook 
{
	[Inject]
	
	public var runCount:uint = 0;
	
	public function hook():void
	{
		runCount++;
	}
}

class TrackableHook1
{
	[Inject]
	public var hookTracker:HookTracker;
	
	public function hook():void
	{
		hookTracker.confirm("TrackableHook1");
	}
}

class TrackableHook2
{
	[Inject]
	public var hookTracker:HookTracker;
	
	public function hook():void
	{
		hookTracker.confirm("TrackableHook2");
	}
}

class HookTracker
{
	public var hooksConfirmed:Vector.<String> = new Vector.<String>();
	
	public function confirm(hookName:String):void
	{
		hooksConfirmed.push(hookName);
	}
}

class ExampleTarget
{
	public function ExampleTarget()
	{
	}
}