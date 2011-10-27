//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guards 
{
	import org.flexunit.asserts.*;
	import org.swiftsuspenders.Injector;
	import ArgumentError;
	import flash.utils.describeType;

	public class GuardsProcessorTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:GuardsProcessor;
		private var injector:Injector;

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
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test]
		public function a_guard_is_run():void
		{
			var happyGuard:HappyGuard = new HappyGuard();
			assertTrue("HappyGuard returns true", happyGuard.approve());
		}
		
		[Test]
		public function processing_happy_guard_returns_true():void
		{
			var requiredGuards:Vector.<Class> = new <Class>[HappyGuard];
			assertTrue("processor returned true with happy guard", processGuards(injector, requiredGuards));
		}
		
		[Test]
		public function processing_grumpy_guard_returns_false():void
		{
			var requiredGuards:Vector.<Class> = new <Class>[GrumpyGuard];
			assertFalse("processor returned false with grumpy guard", processGuards(injector, requiredGuards));
		}
		
		[Test]
		public function processing_guards_including_a_grumpy_guard_returns_false():void
		{
			var requiredGuards:Vector.<Class> = new <Class>[HappyGuard, GrumpyGuard];
			assertFalse("processor returned false with a grumpy guard in the mix", processGuards(injector, requiredGuards));
		}
		
		[Test]
		public function processing_guard_with_injections_returns_true_if_injected_guard_says_so():void
		{
			injector.map(BossDecision).toValue(new BossDecision(true));
			var requiredGuards:Vector.<Class> = new <Class>[JustTheMiddleManGuard];
			assertTrue("processor returned true with happy boss", processGuards(injector, requiredGuards));
		}
		
		[Test]
		public function processing_guard_with_injections_returns_false_if_injected_guard_says_so():void
		{
			injector.map(BossDecision).toValue(new BossDecision(false));
			var requiredGuards:Vector.<Class> = new <Class>[JustTheMiddleManGuard];
			assertFalse("processor returned false with grumpy boss", processGuards(injector, requiredGuards));
		}
		
		[Test(expects="ArgumentError")]
		public function throws_error_if_a_non_guard_is_passed():void
		{
			var requiredGuards:Vector.<Class> = new <Class>[HappyGuard, NotAGuard];
			processGuards(injector, requiredGuards);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		protected function processGuards(useInjector:Injector, guardClasses:Vector.<Class>):Boolean
		{
			verifyGuardClasses(guardClasses);
			
			var guard:*;
			
			for each (var guardClass:Class in guardClasses)
			{
				guard = useInjector.getInstance(guardClass);
				if(! guard.approve())
					return false;
			}
			
			return true;
		}
		
		protected function verifyGuardClasses(guardClasses:Vector.<Class>):void
		{
			for each (var guardClass:Class in guardClasses)
			{
				if(!(describeType(guardClass).factory.method.(@name == "approve").length() == 1))
				{
					throw new ArgumentError("No approve function found on class " + guardClass);
				}
			}
		}
		
	}
}

class HappyGuard
{
	public function approve():Boolean
	{
		return true;
	}
}

class GrumpyGuard
{
	public function approve():Boolean
	{
		return false;
	}
}

class JustTheMiddleManGuard
{
	[Inject]
	public var bossDecision:BossDecision;
	
	public function approve():Boolean
	{
		return bossDecision.approve();
	}
}

class BossDecision
{
	public function BossDecision(approve:Boolean)
	{
		_approve = approve;
	}
	
	protected var _approve:Boolean;
	
	public function approve():Boolean
	{
		return _approve;
	}
}

class NotAGuard
{
	public function iDontApprove():Boolean
	{
		return false;
	}
}