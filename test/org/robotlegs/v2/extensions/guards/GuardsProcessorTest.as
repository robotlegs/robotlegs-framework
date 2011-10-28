//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guards
{
	import flash.utils.describeType;
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.extensions.guards.support.*
	import org.swiftsuspenders.Injector;

	public class GuardsProcessorTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var instance:GuardsProcessor;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new GuardsProcessor();
			injector = new Injector();
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
			assertTrue("instance is GuardsProcessor", instance is GuardsProcessor);
		}

		[Test]
		public function processing_grumpy_guard_returns_false():void
		{
			var requiredGuards:Vector.<Class> = new <Class>[GrumpyGuard];
			assertFalse("processor returned false with grumpy guard", instance.processGuards(injector, requiredGuards));
		}

		[Test]
		public function processing_guard_with_injections_returns_false_if_injected_guard_says_so():void
		{
			injector.map(BossGuard).toValue(new BossGuard(false));
			var requiredGuards:Vector.<Class> = new <Class>[JustTheMiddleManGuard];
			assertFalse("processor returned false with grumpy boss", instance.processGuards(injector, requiredGuards));
		}

		[Test]
		public function processing_guard_with_injections_returns_true_if_injected_guard_says_so():void
		{
			injector.map(BossGuard).toValue(new BossGuard(true));
			var requiredGuards:Vector.<Class> = new <Class>[JustTheMiddleManGuard];
			assertTrue("processor returned true with happy boss", instance.processGuards(injector, requiredGuards));
		}

		[Test]
		public function processing_guards_including_a_grumpy_guard_returns_false():void
		{
			var requiredGuards:Vector.<Class> = new <Class>[HappyGuard, GrumpyGuard];
			assertFalse("processor returned false with a grumpy guard in the mix", instance.processGuards(injector, requiredGuards));
		}

		[Test]
		public function processing_happy_guard_returns_true():void
		{
			var requiredGuards:Vector.<Class> = new <Class>[HappyGuard];
			assertTrue("processor returned true with happy guard", instance.processGuards(injector, requiredGuards));
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test(expects="ArgumentError")]
		public function throws_error_if_a_non_guard_is_passed():void
		{
			var requiredGuards:Vector.<Class> = new <Class>[HappyGuard, NotAGuard];
			instance.processGuards(injector, requiredGuards);
		}
	/*============================================================================*/
	/* Protected Functions                                                        */
	/*============================================================================*/
	}
}

class NotAGuard
{

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function iDontApprove():Boolean
	{
		return false;
	}
}
