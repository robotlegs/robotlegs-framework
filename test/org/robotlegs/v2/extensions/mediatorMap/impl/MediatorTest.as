//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl 
{
	import org.flexunit.asserts.*;

	public class MediatorTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:Mediator;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new Mediator();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is Mediator", instance is Mediator);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", false);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}