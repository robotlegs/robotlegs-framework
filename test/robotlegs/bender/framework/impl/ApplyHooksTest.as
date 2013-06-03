//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.hookSupport.CallbackHook;

	public class ApplyHooksTest
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
		public function function_hooks_run():void
		{
			var callCount:int = 0;
			applyHooks([function():void {
				callCount++;
			}]);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function class_hooks_run():void
		{
			var callCount:int = 0;
			injector.map(Function, 'hookCallback').toValue(function():void {
				callCount++;
			});
			applyHooks([CallbackHook], injector);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function instance_hooks_run():void
		{
			var callCount:int = 0;
			const hook:CallbackHook = new CallbackHook(function():void {
				callCount++;
			});
			applyHooks([hook]);
			assertThat(callCount, equalTo(1));
		}

		[Test(expects="TypeError")]
		public function instance_without_hook_throws_error():void
		{
			var invalidHook:Object = {};
			applyHooks([invalidHook]);
			// note: no assertion. we just want to know if an error is thrown
		}
	}
}
