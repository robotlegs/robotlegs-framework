//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.messaging
{
	import flash.utils.setTimeout;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.core.async.support.createAsyncHandler;
	import robotlegs.bender.core.async.support.createCallbackHandlerThatErrors;
	import robotlegs.bender.core.async.support.createHandler;

	public class MessageDispatcherTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var dispatcher:MessageDispatcher;

		private var message:Object;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			dispatcher = new MessageDispatcher();
			message = new Object();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function function_length_assumptions():void
		{
			const func:Function = function(a:String, b:String, c:String = ''):void
			{
				assertThat(arguments.length, equalTo(2));
			};
			func("", "");
			assertThat(func.length, equalTo(3));
		}

		[Test]
		public function addMessageHandler_runs():void
		{
			dispatcher.addMessageHandler(message, new Function());
		}

		[Test]
		public function addMessageHandler_stores_handler():void
		{
			dispatcher.addMessageHandler(message, new Function());
			assertThat(dispatcher.hasMessageHandler(message), isTrue());
		}

		[Test]
		public function hasMessageHandler_runs():void
		{
			dispatcher.hasMessageHandler(message);
		}

		[Test]
		public function hasMessageHandler_returns_false():void
		{
			assertThat(dispatcher.hasMessageHandler(message), isFalse());
		}

		[Test]
		public function hasMessageHandler_returns_true():void
		{
			dispatcher.addMessageHandler(message, new Function());
			assertThat(dispatcher.hasMessageHandler(message), isTrue());
		}

		[Test]
		public function hasMessageHandler_returns_false_for_wrong_message():void
		{
			dispatcher.addMessageHandler("abcde", new Function());
			assertThat(dispatcher.hasMessageHandler(message), isFalse());
		}

		[Test]
		public function removeMessageHandler_runs():void
		{
			dispatcher.removeMessageHandler(message, new Function());
		}

		[Test]
		public function removeMessageHandler_removes_the_handler():void
		{
			const handler:Function = new Function();
			dispatcher.addMessageHandler(message, handler);
			dispatcher.removeMessageHandler(message, handler);
			assertThat(dispatcher.hasMessageHandler(message), isFalse());
		}

		[Test]
		public function removeMessageHandler_does_not_remove_the_wrong_handler():void
		{
			const handler:Function = new Function();
			const otherHandler:Function = new Function();
			dispatcher.addMessageHandler(message, handler);
			dispatcher.addMessageHandler(message, otherHandler);
			dispatcher.removeMessageHandler(message, otherHandler);
			assertThat(dispatcher.hasMessageHandler(message), isTrue());
		}

		[Test]
		public function dispatchMessage_runs():void
		{
			dispatcher.dispatchMessage(message);
		}

		[Test]
		public function deaf_handler_handles_message():void
		{
			var handled:Boolean = false;
			dispatcher.addMessageHandler(message, function():void {
				handled = true;
			});
			dispatcher.dispatchMessage(message);
			assertThat(handled, isTrue());
		}

		[Test]
		public function handler_handles_message():void
		{
			var actualMessage:Object;
			dispatcher.addMessageHandler(message, function(msg:Object):void {
				actualMessage = msg;
			});
			dispatcher.dispatchMessage(message);
			assertThat(actualMessage, equalTo(message));
		}

		[Test]
		public function message_is_handled_by_multiple_handlers():void
		{
			var handleCount:int = 0;
			dispatcher.addMessageHandler(message, function():void {
				handleCount++;
			});
			dispatcher.addMessageHandler(message, function():void {
				handleCount++;
			});
			dispatcher.addMessageHandler(message, function():void {
				handleCount++;
			});
			dispatcher.dispatchMessage(message);
			assertThat(handleCount, equalTo(3));
		}

		[Test]
		public function message_is_handled_by_handler_multiple_times():void
		{
			var handleCount:int;
			dispatcher.addMessageHandler(message, function():void {
				handleCount++;
			});
			dispatcher.dispatchMessage(message);
			dispatcher.dispatchMessage(message);
			dispatcher.dispatchMessage(message);
			assertThat(handleCount, equalTo(3));
		}

		[Test]
		public function handler_does_not_handle_the_wrong_message():void
		{
			var handled:Boolean;
			dispatcher.addMessageHandler(message, function():void {
				handled = true;
			});
			dispatcher.dispatchMessage("abcde");
			assertThat(handled, isFalse());
		}

		[Test]
		public function handler_with_callback_handles_message():void
		{
			var actualMessage:Object;
			dispatcher.addMessageHandler(message, function(msg:Object, callback:Function):void {
				actualMessage = msg;
				callback();
			});
			dispatcher.dispatchMessage(message);
			assertThat(actualMessage, equalTo(message));
		}

		[Test(async)]
		public function async_handler_handles_message():void
		{
			var actualMessage:Object;
			dispatcher.addMessageHandler(message, function(msg:Object, callback:Function):void {
				actualMessage = msg;
				setTimeout(callback, 5);
			});
			dispatcher.dispatchMessage(message);
			delayAssertion(function():void {
				assertThat(actualMessage, equalTo(message));
			});
		}

		[Test]
		public function callback_is_called_once():void
		{
			var callbackCount:int;
			dispatcher.dispatchMessage(message, function():void {
				callbackCount++;
			});
			assertThat(callbackCount, equalTo(1));
		}

		[Test(async)]
		public function callback_is_called_once_after_sync_handler():void
		{
			var callbackCount:int;
			dispatcher.addMessageHandler(message, createHandler());
			dispatcher.dispatchMessage(message, function():void {
				callbackCount++;
			});
			delayAssertion(function():void {
				assertThat(callbackCount, equalTo(1));
			});
		}

		[Test(async)]
		public function callback_is_called_once_after_async_handler():void
		{
			var callbackCount:int;
			dispatcher.addMessageHandler(message, createAsyncHandler());
			dispatcher.dispatchMessage(message, function():void {
				callbackCount++;
			});
			delayAssertion(function():void {
				assertThat(callbackCount, equalTo(1));
			});
		}

		[Test(async)]
		public function callback_is_called_once_after_sync_and_async_handlers():void
		{
			var callbackCount:int;
			dispatcher.addMessageHandler(message, createAsyncHandler());
			dispatcher.addMessageHandler(message, createHandler());
			dispatcher.addMessageHandler(message, createAsyncHandler());
			dispatcher.addMessageHandler(message, createHandler());
			dispatcher.dispatchMessage(message, function():void {
				callbackCount++;
			});
			delayAssertion(function():void {
				assertThat(callbackCount, equalTo(1));
			}, 100);
		}

		[Test]
		public function handler_passes_error_to_callback():void
		{
			const expectedError:Object = "Error";
			var actualError:Object;
			dispatcher.addMessageHandler(message, function(msg:Object, callback:Function):void {
				callback(expectedError);
			});
			dispatcher.dispatchMessage(message, function(error:Object):void {
				actualError = error;
			});
			assertThat(actualError, equalTo(expectedError));
		}

		[Test(async)]
		public function async_handler_passes_error_to_callback():void
		{
			const expectedError:Object = "Error";
			var actualError:Object;
			dispatcher.addMessageHandler(message, function(msg:Object, callback:Function):void {
				setTimeout(callback, 5, expectedError);
			});
			dispatcher.dispatchMessage(message, function(error:Object):void {
				actualError = error;
			});
			delayAssertion(function():void {
				assertThat(actualError, equalTo(expectedError));
			});
		}

		[Test]
		public function handler_that_calls_back_more_than_once_is_ignored():void
		{
			var callbackCount:int;
			dispatcher.addMessageHandler(message, function(msg:Object, callback:Function):void {
				callback();
				callback();
			});
			dispatcher.dispatchMessage(message, function(error:Object):void {
				callbackCount++
			});
			assertThat(callbackCount, equalTo(1));
		}

		[Test(async)]
		public function async_handler_that_calls_back_more_than_once_is_ignored():void
		{
			var callbackCount:int;
			dispatcher.addMessageHandler(message, function(msg:Object, callback:Function):void {
				callback();
				callback();
			});
			dispatcher.dispatchMessage(message, function(error:Object):void {
				callbackCount++
			});
			delayAssertion(function():void {
				assertThat(callbackCount, equalTo(1));
			});
		}

		[Test]
		public function sync_handlers_should_run_in_order():void
		{
			for each (var reverse:Boolean in[false, true])
			{
				const actual:Array = [];
				const expected:Array = ['handler 1', 'handler 2', 'handler 3', 'handler 4'];
				reverse && expected.reverse();
				dispatcher = new MessageDispatcher();
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 1'));
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 2'));
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 3'));
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 4'));
				dispatcher.dispatchMessage(message, null, reverse);
				assertThat("reverse=" + reverse, actual, array(expected));
			}
		}

		[Test(async)]
		public function async_handlers_should_run_in_order():void
		{
			for each (var reverse:Boolean in[false, true])
			{
				const actual:Array = [];
				const expected:Array = ['handler 1', 'handler 2', 'handler 3', 'handler 4'];
				reverse && expected.reverse();
				dispatcher = new MessageDispatcher();
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 1'));
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 2'));
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 3'));
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 4'));
				dispatcher.dispatchMessage(message, null, reverse);
				// gotta close over these otherwise we're just testing the latest twice :)
				(function(reverse:Boolean, actual:Array, expected:Array):void {
					delayAssertion(function():void {
						assertThat("reverse=" + reverse, actual, array(expected));
					}, 200);
				})(reverse, actual, expected);
			}
		}

		[Test(async)]
		public function async_and_sync_handlers_should_run_in_order():void
		{
			for each (var reverse:Boolean in[false, true])
			{
				const actual:Array = [];
				const expected:Array = ['handler 1', 'handler 2', 'handler 3', 'handler 4'];
				reverse && expected.reverse();
				dispatcher = new MessageDispatcher();
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 1'));
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 2'));
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 3'));
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 4'));
				dispatcher.dispatchMessage(message, null, reverse);
				// gotta close over these otherwise we're just testing the latest twice :)
				(function(reverse:Boolean, actual:Array, expected:Array):void {
					delayAssertion(function():void {
						assertThat("reverse=" + reverse, actual, array(expected));
					}, 200);
				})(reverse, actual, expected);
			}
		}

		[Test]
		public function terminated_message_should_not_reach_further_handlers():void
		{
			for each (var reverse:Boolean in[false, true])
			{
				const actual:Array = [];
				const expected:Array = reverse
                    ? ['handler 4', 'handler 3 (with error)']
					: ['handler 1', 'handler 2', 'handler 3 (with error)'];
				dispatcher = new MessageDispatcher();
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 1'));
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 2'));
				dispatcher.addMessageHandler(message, createCallbackHandlerThatErrors(actual.push, 'handler 3 (with error)'));
				dispatcher.addMessageHandler(message, createHandler(actual.push, 'handler 4'));
				dispatcher.dispatchMessage(message, null, reverse);
				assertThat("reverse=" + reverse, actual, array(expected));
			}
		}

		[Test(async)]
		public function terminated_async_message_should_not_reach_further_handlers():void
		{
			for each (var reverse:Boolean in [false, true])
			{
				const actual:Array = [];
				const expected:Array = reverse
                    ? ['handler 4', 'handler 3 (with error)']
					: ['handler 1', 'handler 2', 'handler 3 (with error)'];
				dispatcher = new MessageDispatcher();
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 1'));
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 2'));
				dispatcher.addMessageHandler(message, createCallbackHandlerThatErrors(actual.push, 'handler 3 (with error)'));
				dispatcher.addMessageHandler(message, createAsyncHandler(actual.push, 'handler 4'));
				dispatcher.dispatchMessage(message, null, reverse);
				// gotta close over these otherwise we're just testing the latest twice :)
				(function(reverse:Boolean, actual:Array, expected:Array):void {
					delayAssertion(function():void {
						assertThat("reverse=" + reverse, actual, array(expected));
					}, 200);
				})(reverse, actual, expected);
			}
		}

        [Test]
        public function handler_is_only_added_once():void
        {
            var callbackCount:int = 0;
            const handler:Function = function():void{
				callbackCount++;
            };
            dispatcher.addMessageHandler(message, handler);
            dispatcher.addMessageHandler(message, handler);
			dispatcher.dispatchMessage(message);
            assertThat(callbackCount, equalTo(1));
        }

        /*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function delayAssertion(closure:Function, delay:Number = 50):void
		{
			Async.delayCall(this, closure, delay);
		}

	}
}
