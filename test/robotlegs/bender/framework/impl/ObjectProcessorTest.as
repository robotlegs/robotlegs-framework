//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;

	import robotlegs.bender.extensions.matching.instanceOfType;
	import robotlegs.bender.framework.impl.safelyCallBackSupport.createHandler;

	public class ObjectProcessorTest
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var objectProcessor:ObjectProcessor;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			objectProcessor = new ObjectProcessor();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function addObjectHandler():void
		{
			objectProcessor.addObjectHandler(instanceOfType(String), new Function());
		}

		[Test]
		public function addObject():void
		{
			objectProcessor.processObject({});
		}

		[Test]
		public function handler_handles_object():void
		{
			const expected:Object = "string";
			var actual:Object = null;
			objectProcessor.addObjectHandler(instanceOfType(String), function(object:Object):void {
				actual = object;
			});
			objectProcessor.processObject(expected);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function handler_does_not_handle_wrong_object():void
		{
			const expected:Object = "string";
			var actual:Object = null;
			objectProcessor.addObjectHandler(instanceOfType(Boolean), function(object:Object):void {
				actual = object;
			});
			objectProcessor.processObject(expected);
			assertThat(actual, not(expected));
		}

		[Test]
		public function handlers_handle_object():void
		{
			const expected:Array = ['handler1', 'handler2', 'handler3'];
			var actual:Array = [];
			objectProcessor.addObjectHandler(instanceOfType(String), createHandler(actual.push, 'handler1'));
			objectProcessor.addObjectHandler(instanceOfType(String), createHandler(actual.push, 'handler2'));
			objectProcessor.addObjectHandler(instanceOfType(String), createHandler(actual.push, 'handler3'));
			objectProcessor.processObject("string");
			assertThat(actual, array(expected));
		}
	}
}
