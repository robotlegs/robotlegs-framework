//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.objectProcessor.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.core.async.support.createCallbackHandlerThatErrors;
	import robotlegs.bender.core.async.support.createHandler;
	import robotlegs.bender.core.messaging.IMessageDispatcher;
	import robotlegs.bender.core.messaging.MessageDispatcher;
	import robotlegs.bender.core.objectProcessor.api.IObjectProcessor;

	public class ObjectProcessorTest
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var dispatcher:IMessageDispatcher;

		protected var objectProcessor:IObjectProcessor;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			dispatcher = new MessageDispatcher();
			objectProcessor = new ObjectProcessor(dispatcher);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_instantiate():void
		{
			assertThat(objectProcessor, isA(IObjectProcessor));
		}

		[Test]
		public function addObjectHandler():void
		{
			objectProcessor.addObjectHandler(instanceOf(String), new Function());
		}

		[Test]
		public function addObject():void
		{
			objectProcessor.addObject({});
		}

		[Test]
		public function handler_handles_object():void
		{
			const expected:Object = "string";
			var actual:Object;
			objectProcessor.addObjectHandler(instanceOf(String), function(object:Object):void {
				actual = object;
			});
			objectProcessor.addObject(expected);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function handler_does_not_handle_wrong_object():void
		{
			const expected:Object = "string";
			var actual:Object;
			objectProcessor.addObjectHandler(instanceOf(Boolean), function(object:Object):void {
				actual = object;
			});
			objectProcessor.addObject(expected);
			assertThat(actual, not(expected));
		}

		[Test]
		public function handlers_handle_object():void
		{
			const expected:Array = ['handler1', 'handler2', 'handler3'];
			var actual:Array = [];
			objectProcessor.addObjectHandler(instanceOf(String), createHandler(actual.push, 'handler1'));
			objectProcessor.addObjectHandler(instanceOf(String), createHandler(actual.push, 'handler2'));
			objectProcessor.addObjectHandler(instanceOf(String), createHandler(actual.push, 'handler3'));
			objectProcessor.addObject("string");
			assertThat(actual, array(expected));
		}

		[Test]
		public function handlers_can_abort():void
		{
			const expected:Array = ['handler1', 'handler2'];
			var actual:Array = [];
			objectProcessor.addObjectHandler(instanceOf(String), createHandler(actual.push, 'handler1'));
			objectProcessor.addObjectHandler(instanceOf(String), createCallbackHandlerThatErrors(actual.push, 'handler2'));
			objectProcessor.addObjectHandler(instanceOf(String), createHandler(actual.push, 'handler3'));
			objectProcessor.addObjectHandler(instanceOf(String), createHandler(actual.push, 'handler4'));
			objectProcessor.addObject("string");
			assertThat(actual, array(expected));
		}

		[Test]
		public function callback_is_called():void
		{
			var callbackCount:int;
			objectProcessor.addObject({}, function():void {
				callbackCount++;
			});
			assertThat(callbackCount, equalTo(1));
		}
	}
}
