//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guards.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.robotlegs.v2.extensions.guards.api.IGuardGroup;
	import org.robotlegs.v2.extensions.guards.support.BossGuard;
	import org.robotlegs.v2.extensions.guards.support.GrumpyGuard;
	import org.robotlegs.v2.extensions.guards.support.HappyGuard;
	import org.robotlegs.v2.extensions.guards.support.JustTheMiddleManGuard;
	import org.swiftsuspenders.Injector;

	public class GuardGroupTests
	{

		private var injector:Injector;

		private var guards:IGuardGroup;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			guards = new GuardGroup(injector);
		}

		[After]
		public function tearDown():void
		{
			guards = null;
			injector = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertThat(guards, instanceOf(IGuardGroup));
		}

		[Test]
		public function processing_grumpy_guard_returns_false():void
		{
			guards.add(GrumpyGuard);
			assertThat(guards.approve(), isFalse());
		}

		[Test]
		public function processing_guard_with_injections_returns_false_if_injected_guard_says_so():void
		{
			injector.map(BossGuard).toValue(new BossGuard(false));
			guards.add(JustTheMiddleManGuard);
			assertThat(guards.approve(), isFalse());
		}

		[Test]
		public function processing_guard_with_injections_returns_true_if_injected_guard_says_so():void
		{
			injector.map(BossGuard).toValue(new BossGuard(true));
			guards.add(JustTheMiddleManGuard);
			assertThat(guards.approve(), isTrue());
		}

		[Test]
		public function processing_guards_including_a_grumpy_guard_returns_false():void
		{
			guards.add(HappyGuard, GrumpyGuard);
			assertThat(guards.approve(), isFalse());
		}

		[Test]
		public function processing_happy_guard_returns_true():void
		{
			guards.add(HappyGuard);
			assertThat(guards.approve(), isTrue());
		}

		[Test(expects="ArgumentError")]
		public function throws_error_if_a_non_guard_is_passed():void
		{
			guards.add(HappyGuard, NotAGuard);
			guards.approve();
		}
	}
}

class NotAGuard
{

	public function iDontApprove():Boolean
	{
		return false;
	}
}
