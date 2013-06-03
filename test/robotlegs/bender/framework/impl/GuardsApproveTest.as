//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.guardSupport.BossGuard;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;
	import robotlegs.bender.framework.impl.guardSupport.JustTheMiddleManGuard;

	public class GuardsApproveTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:IInjector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new RobotlegsInjector();
		}

		[After]
		public function after():void
		{
			injector = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function grumpy_Function_returns_false():void
		{
			assertThat(guardsApprove([grumpyFunction]), isFalse());
		}

		[Test]
		public function happy_Function_returns_true():void
		{
			assertThat(guardsApprove([happyFunction]), isTrue());
		}

		[Test]
		public function grumpy_Class_returns_false():void
		{
			assertThat(guardsApprove([GrumpyGuard]), isFalse());
		}

		[Test]
		public function happy_Class_returns_true():void
		{
			assertThat(guardsApprove([HappyGuard]), isTrue());
		}

		[Test]
		public function grumpy_Instance_returns_false():void
		{
			assertThat(guardsApprove([new GrumpyGuard()]), isFalse());
		}

		[Test]
		public function happy_Instance_returns_true():void
		{
			assertThat(guardsApprove([new HappyGuard()]), isTrue());
		}

		[Test]
		public function guard_with_injections_returns_false_if_injected_guard_says_so():void
		{
			injector.map(BossGuard).toValue(new BossGuard(false));
			assertThat(guardsApprove([JustTheMiddleManGuard], injector), isFalse());
		}

		[Test]
		public function guard_with_injections_returns_true_if_injected_guard_says_so():void
		{
			injector.map(BossGuard).toValue(new BossGuard(true));
			assertThat(guardsApprove([JustTheMiddleManGuard], injector), isTrue());
		}

		[Test]
		public function guards_with_a_grumpy_Class_returns_false():void
		{
			assertThat(guardsApprove([HappyGuard, GrumpyGuard]), isFalse());
		}

		[Test]
		public function guards_with_a_grumpy_Instance_returns_false():void
		{
			assertThat(guardsApprove([new HappyGuard(), new GrumpyGuard()]), isFalse());
		}

		[Test]
		public function guards_with_a_grumpy_Function_returns_false():void
		{
			assertThat(guardsApprove([happyFunction, grumpyFunction]), isFalse());
		}

		[Test]
		public function falsey_Function_returns_false():void
		{
			var falseyGuard:Function = function():int {
				return 0;
			};
			assertThat(guardsApprove([falseyGuard]), isFalse());
		}

		[Test]
		public function falsey_approve_returns_false():void
		{
			var falseyGuard:Object = {
					approve: function():int {
						return 0;
					}
				};
			assertThat(guardsApprove([falseyGuard]), isFalse());
		}

		[Test(expects="TypeError")]
		public function guard_instance_without_approve_throws_error():void
		{
			var invalidGuard:Object = {};
			guardsApprove([invalidGuard]);
			// note: no assertion. we just want to know if an error is thrown
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function happyFunction():Boolean
		{
			return true;
		}

		private function grumpyFunction():Boolean
		{
			return false;
		}
	}
}
