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

	public class HooksProcessorTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:HooksProcessor;
		
		private var injector:Injector;

		private const hookTracker:HookTracker = new HookTracker();
		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new HooksProcessor();
			injector = new Injector();
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
			assertTrue("instance is HooksProcessor", instance is HooksProcessor);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test]	
		public function a_number_of_hooks_are_run():void
		{
			var requiredHooks:Vector.<Class> = new <Class>[TrackableHook1, TrackableHook2];
			instance.runHooks(injector, requiredHooks);
			
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}	
		
		[Test(expects='ArgumentError')]
		public function a_non_hook_causes_us_to_throw_an_argument_error():void
		{
			var requiredHooks:Vector.<Class> = new <Class>[TrackableHook1, TrackableHook2, NonHook];
			instance.runHooks(injector, requiredHooks);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
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

class NonHook
{
	[Inject]
	public var hookTracker:HookTracker;

	public function noHooksHere():void
	{
		hookTracker.confirm("NonHook");
	}
}