//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks 
{
	import org.flexunit.asserts.*;

	public class HookUtilityMapTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:HookUtilityMap;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new HookUtilityMap();
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
			assertTrue("instance is HookUtilityMap", instance is HookUtilityMap);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function a_hook_is_instantiated_and_run():void
		{
			var exampleHook:ExampleHook = new ExampleHook();
			exampleHook.hook();
			//assertEquals("the example hook has been run", 1, runCount);
		}
		
		// a_hook_is_given_injections_correctly
		
		// always_returns_non_blocking_bitmask
		
		// returns_true_if_interested
		
		// returns_false_if_not_interested
		
		// runs_correct_hook_for_one_object

		// runs_correct_hook_for_other_object
		
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
	public var runCount:uint = 0;
	
	public function hook():void
	{
		runCount++;
	}
}