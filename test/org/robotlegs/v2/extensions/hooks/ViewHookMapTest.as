//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	import org.robotlegs.v2.extensions.hooks.support.HookTracker;
	import org.robotlegs.v2.extensions.hooks.support.TrackableHook1;
	import org.robotlegs.v2.extensions.hooks.support.TrackableHook2;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;

	public class ViewHookMapTest
	{

		private var hookTracker:HookTracker;

		private var injector:Injector;

		private var instance:ViewHookMap;

		[Before]
		public function setUp():void
		{
			instance = new ViewHookMap();
			injector = new Injector();
			hookTracker = new HookTracker();
			instance.hookMap = new HookMap();
			instance.hookMap.injector = injector;
			instance.hookMap.reflector = new DescribeTypeJSONReflector();
			instance.hookMap.hooksProcessor = new HooksProcessor();
			instance.hookMap.guardsProcessor = new GuardsProcessor();

			injector.map(HookTracker).toValue(hookTracker);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is ViewHookMap", instance is ViewHookMap);
		}

		[Test]
		public function handleViewAdded_returns_0_if_not_interested():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).withHooks(TrackableHook1, TrackableHook2);
			const returned:uint = instance.processView(new Sprite(), null);
			assertEquals(0, returned);
		}

		[Test]
		public function handleViewAdded_returns_1_if_interested():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).withHooks(TrackableHook1, TrackableHook2);
			const returned:uint = instance.processView(new Sprite(), null);
			assertEquals(1, returned);
		}

		[Test]
		public function implements_IViewHandler():void
		{
			assertTrue("instance is IViewHandler", instance is IViewHandler);
		}

		[Test]
		public function running_handler_with_view_that_doesnt_match_mapping_doesnt_make_hooks_run():void
		{
			instance.map(MovieClip).withHooks(TrackableHook1, TrackableHook2);
			instance.processView(new Sprite(), null);

			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function running_handler_with_view_that_doesnt_match_matcher_mapping_doesnt_make_hooks_run():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).withHooks(TrackableHook1, TrackableHook2);
			instance.processView(new Sprite(), null);

			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function running_handler_with_view_that_matches_mapping_makes_hooks_run():void
		{
			instance.map(Sprite).withHooks(TrackableHook1, TrackableHook2);
			instance.processView(new Sprite(), null);

			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function running_handler_with_view_that_matches_matcher_mapping_makes_hooks_run():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).withHooks(TrackableHook1, TrackableHook2);
			instance.processView(new Sprite(), null);

			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder(expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
	}
}
