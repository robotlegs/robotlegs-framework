//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import asunit.framework.TestCase;
	import org.robotlegs.v2.core.api.ITypeFilter;

	public class TypeFilterTest extends TestCase
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const ALL_OF:Vector.<Class> = new <Class>[uint, Number];

		private const ANY_OF:Vector.<Class> = new <Class>[Sprite, IEventDispatcher];

		private const NONE_OF:Vector.<Class> = new <Class>[String, Error];

		private var instance:TypeFilter;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function TypeFilterTest(methodName:String = null)
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

		public function testImplementsInterface():void
		{
			assertTrue("instance implements ITypeFilter", instance is ITypeFilter);
		}

		public function testInstantiated():void
		{
			assertTrue("instance is TypeFilter", instance is TypeFilter);
		}

		public function test_get_allOfTypes():void
		{
			assertEquals("Get allOfTypes", ALL_OF, instance.allOfTypes);
		}

		public function test_get_anyOfTypes():void
		{
			assertEquals("Get anyOfTypes", ANY_OF, instance.anyOfTypes);
		}

		public function test_get_descriptor_returns_alphabetised_readable_list():void
		{
			var expected:String = "all of: uint,Number, any of: flash.events::IEventDispatcher,flash.display::Sprite, none of: String,Error";
			assertEquals("Get descriptor returns alphabetised, readable list", expected, instance.descriptor);
		}

		public function test_get_noneOfTypes():void
		{
			assertEquals("Get noneOfTypes", NONE_OF, instance.noneOfTypes);
		}

		public function test_self_initalises_null_values():void
		{
			var nullFilter:TypeFilter = new TypeFilter(null, null, null);
			assertTrue("Self initalises null values", instance.allOfTypes && instance.anyOfTypes && instance.noneOfTypes);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		override protected function setUp():void
		{
			super.setUp();
			instance = new TypeFilter(ALL_OF, ANY_OF, NONE_OF);
		}

		override protected function tearDown():void
		{
			super.tearDown();
			instance = null;
		}
	}
}
