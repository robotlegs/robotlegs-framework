//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks 
{
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.view.api.IViewHandler;
	import org.swiftsuspenders.Injector;
	import org.robotlegs.v2.extensions.hooks.support.TrackableHook1;
	import org.robotlegs.v2.extensions.hooks.support.TrackableHook2;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import org.robotlegs.v2.extensions.hooks.support.HookTracker;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import flash.display.DisplayObject;

	public class ViewHookMapTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:ViewHookMap;
		
		private var injector:Injector;

		private var hookTracker:HookTracker;
		

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new ViewHookMap();
			injector = new Injector();
			hookTracker = new HookTracker();
			instance.hookMap = new HookMap();
			instance.hookMap.injector = injector;
			instance.hookMap.hooksProcessor = new HooksProcessor();
			instance.hookMap.guardsProcessor = new GuardsProcessor();
			
			injector.map(HookTracker).toValue(hookTracker);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is ViewHookMap", instance is ViewHookMap);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function implements_IViewHandler():void
		{
			assertTrue("instance is IViewHandler", instance is IViewHandler);
		}
		
		[Test]
		public function running_handler_with_view_that_matches_mapping_makes_hooks_run():void
		{
			instance.map(Sprite).toHooks(TrackableHook1, TrackableHook2);
			instance.handleViewAdded(new Sprite(), null);

			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function running_handler_with_view_that_doesnt_match_mapping_doesnt_make_hooks_run():void
		{
			instance.map(MovieClip).toHooks(TrackableHook1, TrackableHook2);
			instance.handleViewAdded(new Sprite(), null);

			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function running_handler_with_view_that_matches_matcher_mapping_makes_hooks_run():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toHooks(TrackableHook1, TrackableHook2);
			instance.handleViewAdded(new Sprite(), null);

			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder(expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function running_handler_with_view_that_doesnt_match_matcher_mapping_doesnt_make_hooks_run():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).toHooks(TrackableHook1, TrackableHook2);
			instance.handleViewAdded(new Sprite(), null);

			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}