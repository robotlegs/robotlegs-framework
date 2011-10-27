//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks 
{
	import org.flexunit.asserts.*;
	import org.swiftsuspenders.Injector;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import ArgumentError;
	import flash.utils.describeType;

	public class HooksProcessorTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:HooksProcessor;
		
		private var injector:Injector;
		
		private const SINGLE_TEXT:String = "single_text";
		private const DOUBLED_TEXT:String = SINGLE_TEXT+SINGLE_TEXT;
		
		private const hookTracker:HookTracker = new HookTracker();
		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new HooksProcessor();
			injector = new Injector();
			injector.map(String).toValue(SINGLE_TEXT);
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
			assertTrue("instance is HooksProcessor", instance is HooksProcessor);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test]
		public function a_hook_is_run():void
		{
			var exampleHook:ExampleHook = new ExampleHook();
			exampleHook.hook();
			assertEquals("the example hook has been run", 1, exampleHook.runCount);
		}
		
		[Test]
		public function a_hook_is_given_injections_correctly():void
		{
			var exampleHook:ExampleHookWithInjection = injector.getInstance(ExampleHookWithInjection);
			exampleHook.hook();
			assertEquals("the example hook has been run", DOUBLED_TEXT, exampleHook.doubled);
		}

		// a number of hooks are run
		[Test]	
		public function a_number_of_hooks_are_run():void
		{
			var requiredHooks:Vector.<Class> = new <Class>[TrackableHook1, TrackableHook2];
			for each (var hookClass:Class in requiredHooks)
			{
				var hook:* = injector.getInstance(hookClass);
				hook.hook();
			}
			
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}	
		
		[Test(expects='ArgumentError')]
		public function a_non_hook_causes_us_to_throw_an_argument_error():void
		{
			var requiredHooks:Vector.<Class> = new <Class>[TrackableHook1, TrackableHook2, NonHook];
			for each (var hookClass:Class in requiredHooks)
			{
				if(! (describeType(hookClass).factory.method.(@name == "hook").length() == 1))
				{
					throw new ArgumentError("No hook function found on class " + hookClass);
				}
				var hook:* = injector.getInstance(hookClass);
				hook.hook();
			}
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}

class ExampleHook 
{
	public var runCount:uint = 0;
	
	public function hook():void
	{
		runCount++;
	}
}

class ExampleHookWithInjection
{
	[Inject]
	public var someInjectedVar:String;
	
	public var doubled:String;
	
	public function hook():void
	{
		doubled = someInjectedVar + someInjectedVar;
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