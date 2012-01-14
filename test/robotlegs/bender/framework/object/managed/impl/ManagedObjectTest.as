//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.object.managed.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.core.async.support.createHandler;
	import robotlegs.bender.framework.object.managed.api.IManagedObject;

	public class ManagedObjectTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var targetObject:Object;

		private var managedObject:ManagedObject;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			targetObject = {};
			managedObject = new ManagedObject(targetObject);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function go():void
		{
			assertThat(managedObject, isA(IManagedObject));
		}

		[Test]
		public function get_object():void
		{
			assertThat(managedObject.object, equalTo(targetObject));
		}

		[Test]
		public function initialize():void
		{
			managedObject.initialize();
		}

		[Test]
		public function initialize_calls_callback():void
		{
			var callCount:int;
			managedObject.initialize(function():void {
				callCount++;
			});
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function initialize_callback_receives_error():void
		{
			const expected:Error = new Error("error");
			var actual:Object;
			managedObject.addStateHandler(
				ManagedObject.PRE_INITIALISE,
				function(step:String, callback:Function):void {
					callback(expected);
				});
			managedObject.initialize(function(error:Object):void {
				actual = error;
			});
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function initialize_handled_by_step_handlers():void
		{
			const expected:Array = [
				ManagedObject.PRE_INITIALISE,
				ManagedObject.SELF_INITIALIZE,
				ManagedObject.POST_INITIALIZE];
			var actual:Array = [];
			for each (var step:String in expected)
			{
				managedObject.addStateHandler(step, createHandler(actual.push, step));
			}
			managedObject.initialize();
			assertThat(actual, array(expected));
		}

		[Test]
		public function destroy():void
		{
			managedObject.destroy();
		}

		[Test]
		public function destroy_calls_callback():void
		{
			var callCount:int;
			managedObject.destroy(function():void {
				callCount++;
			});
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function destroy_callback_receives_error():void
		{
			const expected:Error = new Error("error");
			var actual:Object;
			managedObject.addStateHandler(
				ManagedObject.PRE_DESTROY,
				function(step:String, callback:Function):void {
					callback(expected);
				});
			managedObject.destroy(function(error:Object):void {
				actual = error;
			});
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function destroy_handled_by_step_handlers():void
		{
			const expected:Array = [
				ManagedObject.PRE_DESTROY,
				ManagedObject.SELF_DESTROY,
				ManagedObject.POST_DESTROY];
			var actual:Array = [];
			for each (var step:String in expected)
			{
				managedObject.addStateHandler(step, createHandler(actual.push, step));
			}
			managedObject.initialize();
			managedObject.destroy();
			assertThat(actual, array(expected));
		}
	}
}
