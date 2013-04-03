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

	import robotlegs.bender.framework.impl.safelyCallBack;

	public class SafelyCallBackTest
	{

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function callback_with_no_params_is_called():void
		{
			var callCount:int = 0;
			const callback:Function = function():void {
				callCount++;
			};
			safelyCallBack(callback, {}, {});
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function callback_with_one_param_is_called():void
		{
			var callCount:int = 0;
			const callback:Function = function(param:Object):void {
				callCount++;
			};
			safelyCallBack(callback, {}, {});
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function callback_with_two_param_is_called():void
		{
			var callCount:int = 0;
			const callback:Function = function(param1:Object, param2:Object):void {
				callCount++;
			};
			safelyCallBack(callback, {}, {});
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function callback_receives_error():void
		{
			const expected:Object = new Error("Something went hideously wrong.");
			var actual:Object = null;
			const callback:Function = function(error:Object):void {
				actual = error;
			};
			safelyCallBack(callback, expected, {});
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function callback_receives_message():void
		{
			const expected:Object = "message";
			var actual:Object = null;
			const callback:Function = function(error:Object, message:Object):void {
				actual = message;
			};
			safelyCallBack(callback, {}, expected);
			assertThat(actual, equalTo(expected));
		}

		[Test(expects="Error")]
		public function invalid_callback_probably_explodes():void
		{
			const callback:Function = function(error:Object, message:Object, invalidParameter:Object):void {
			};
			safelyCallBack(callback, {}, {});
		}
	}
}
