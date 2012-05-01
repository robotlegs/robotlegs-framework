//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.impl.hookSupport.CallbackHook;
	import robotlegs.bender.framework.impl.applyHooks;

	public class ApplyHooksTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
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
	}
}
