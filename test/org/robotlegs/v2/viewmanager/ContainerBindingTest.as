//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import asunit.framework.TestCase;

	public class ContainerBindingTest extends TestCase
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const CONTAINER_VIEW:DisplayObjectContainer = new Sprite();

		protected const PARENT:ContainerBinding = new ContainerBinding(new Sprite(), removeHandler);

		protected var _removedBinding:IContainerBinding;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:ContainerBinding;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ContainerBindingTest(methodName:String = null)
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
			assertTrue("instance is ContainerBinding", instance is ContainerBinding);
		}

		public function test_get_container():void
		{
			assertEquals("Get container", CONTAINER_VIEW, instance.container);
		}

		public function test_remove_runs_removeHandler_passing_self():void
		{
			instance.remove();
			assertEquals("Remove runs removeHandler passing self ", instance, _removedBinding);
		}

		public function test_set_parent():void
		{
			instance.parent = PARENT;
			assertEquals("Set parent", PARENT, instance.parent);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function removeHandler(binding:IContainerBinding):void
		{
			_removedBinding = binding;
		}

		override protected function setUp():void
		{
			super.setUp();
			instance = new ContainerBinding(CONTAINER_VIEW, removeHandler);
		}

		override protected function tearDown():void
		{
			super.tearDown();
			instance = null;
		}
	}
}
