//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.number.lessThan;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;

	import robotlegs.bender.framework.impl.MessageDispatcher;

	public class MessageDispatcherStressTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var dispatcher:MessageDispatcher;

		private var message:Object;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		// 2012-01-09: Idea - BeforeTest for relative numbers

		[Before(async, timeout="250")]
		public function before():void
		{
			dispatcher = new MessageDispatcher();
			message = {};
		}

		[After(async, timeout="250")]
		public function after():void
		{
			// cool down
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function does_not_overflow_with_deaf_handlers():void
		{
			var overflowed:Boolean;
			// 2012-01-08: 2700 seems to be the limit right now for deaf handlers
			// 2012-01-09: Now unlimited
			// Set at 5000 to prevent regression
			var totalHandlers:int = 5000;
			while (totalHandlers--)
			{
				dispatcher.addMessageHandler(message, new Function());
			}
			try
			{
				dispatcher.dispatchMessage(message);
			}
			catch (error:Error)
			{
				overflowed = true;
			}
			assertThat('overflowed', overflowed, isFalse());
		}

		[Test]
		public function does_not_overflow_with_sync_callbacks():void
		{
			var overflowed:Boolean;
			// 2012-01-08: 1400 seems to be the limit right now for sync callbacks
			var totalHandlers:int = 1400;
			while (totalHandlers--)
			{
				dispatcher.addMessageHandler(message, createSimpleCallbackHandler());
			}
			try
			{
				dispatcher.dispatchMessage(message);
			}
			catch (error:Error)
			{
				overflowed = true;
			}
			assertThat('overflowed', overflowed, isFalse());
		}

		[Test]
		public function sync_deaf_speed_test():void
		{
			var totalHandlers:int = 500;
			var totalDispatches:int = 2000;
			while (totalHandlers--)
				dispatcher.addMessageHandler(message, new Function());
			const start:int = getTimer();
			while (totalDispatches--)
				dispatcher.dispatchMessage(message);
			const took:int = getTimer() - start;
			trace('sync_deaf_speed_test', took); // 2012-01-08: 679, 697, 1002, 673
			assertThat(took, lessThan(1200));
		}

		[Test]
		public function sync_consuming_speed_test():void
		{
			var totalHandlers:int = 500;
			var totalDispatches:int = 2000;
			while (totalHandlers--)
				dispatcher.addMessageHandler(message, new Function());
			const start:int = getTimer();
			while (totalDispatches--)
				dispatcher.dispatchMessage(message);
			const took:int = getTimer() - start;
			trace('sync_consuming_speed_test', took); // 2012-01-08: 1187, 916, 722, 882, 704
			assertThat(took, lessThan(1500));
		}

		[Test]
		public function sync_callback_speed_test():void
		{
			var totalHandlers:int = 500;
			var totalDispatches:int = 2000;
			while (totalHandlers--)
				dispatcher.addMessageHandler(message, createSimpleCallbackHandler());
			const start:int = getTimer();
			while (totalDispatches--)
				dispatcher.dispatchMessage(message);
			const took:int = getTimer() - start;
			trace('sync_callback_speed_test', took); // 2012-01-08: 7696, 7834, 7193, 7023
			assertThat(took, lessThan(9000));
		}

		[Test]
		public function event_speed_test():void
		{
			const eventDispatcher:EventDispatcher = new EventDispatcher();
			const event:Event = new Event("event");
			var totalHandlers:int = 500;
			var totalDispatches:int = 2000;
			while (totalHandlers--)
				eventDispatcher.addEventListener("event", function(event:Event):void {
				});
			const start:int = getTimer();
			while (totalDispatches--)
				eventDispatcher.dispatchEvent(event);
			const took:int = getTimer() - start;
			trace('event_speed_test', took); // 2012-01-08: 644, 653, 699, 760, 1197
			assertThat(took, lessThan(1200));
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		// [Test(async, description="note: takes 30 seconds per 1000 handlers!")]
		public function does_not_overflow_with_9000_async_callbacks():void
		{
			var completed:Boolean;
			var took:int;
			var totalHandlers:int = 9000; // 4.5 minutes!
			const delay:int = totalHandlers * 30;
			while (totalHandlers--)
			{
				dispatcher.addMessageHandler(message, function(msg:Object, callback:Function):void {
					setTimeout(callback, 5);
				});
			}
			// can't try-catch with async handlers
			const start:int = getTimer();
			dispatcher.dispatchMessage(message, function():void {
				took = getTimer() - start;
				completed = true;
			});
			delayTest(function():void {
				assertThat('completed', completed, isTrue());
			}, delay);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function delayTest(closure:Function, delay:Number = 10):void
		{
			Async.delayCall(this, closure, delay);
		}

		private function createSimpleCallbackHandler():Function
		{
			return function(message:Object, callback:Function):void {
				callback();
			};
		}
	}
}
