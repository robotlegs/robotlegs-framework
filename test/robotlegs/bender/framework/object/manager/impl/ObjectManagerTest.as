//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.object.manager.impl
{
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.framework.object.manager.api.IObjectManager;

	public class ObjectManagerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var objectManager:ObjectManager;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			objectManager = new ObjectManager();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_instantiate():void
		{
			assertThat(objectManager, isA(IObjectManager));
		}

		[Test]
		public function addObject():void
		{
			objectManager.addObject({});
		}

		[Test]
		public function addObject_returns_same_managed_object():void
		{
			const object:Object = {};
			assertThat(
				objectManager.addObject(object),
				equalTo(objectManager.addObject(object)));
		}

		[Test]
		public function addObjectHandler():void
		{
			objectManager.addObjectHandler(instanceOf(String), new Function());
		}

		[Test]
		public function getManagedObject():void
		{
			const object:Object = {};
			objectManager.addObject(object);
			assertThat(objectManager.getManagedObject(object).object, equalTo(object));
		}

		[Test]
		public function getManagedObject_returns_null_if_no_managedObject_exists():void
		{
			assertThat(objectManager.getManagedObject({}), nullValue());
		}

		[Test]
		public function object_handlers_should_run():void
		{
			const expected:Sprite = new Sprite();
			var actual:Object;
			objectManager.addObjectHandler(instanceOf(Sprite), function(object:Object):void {
				actual = object;
			});
			objectManager.addObject(expected);
			assertThat(actual, equalTo(expected));
		}
	}
}
