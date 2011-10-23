//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.tasks
{
	import asunit.framework.TestCase;

	public class TaskTypeTest extends TestCase
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const SOME_TYPE:String = "Some type";

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:TaskType;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function TaskTypeTest(methodName:String = null)
		{
			super(methodName)
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function testFailure():void
		{
			assertTrue("Failing test", true);
		}

		public function testInstantiated():void
		{
			assertTrue("instance is TaskType", instance is TaskType);
		}

		public function test_get_type():void
		{
			assertEquals("Get type", SOME_TYPE, instance.type);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		override protected function setUp():void
		{
			super.setUp();
			instance = new TaskType(SOME_TYPE);
		}

		override protected function tearDown():void
		{
			super.tearDown();
			instance = null;
		}
	}
}
