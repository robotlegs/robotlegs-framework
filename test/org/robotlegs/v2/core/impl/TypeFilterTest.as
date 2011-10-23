package org.robotlegs.v2.core.impl {

	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.flexunit.asserts.*;

	public class TypeFilterTest {
		private var instance:TypeFilter;
		
		private const ALL_OF:Vector.<Class> = new <Class>[uint, Number];
		private const ANY_OF:Vector.<Class>	= new <Class>[Sprite, IEventDispatcher];
		private const NONE_OF:Vector.<Class> = new <Class>[String, Error];
		
		[Before]
		public function setUp():void {
			instance = new TypeFilter(ALL_OF, ANY_OF, NONE_OF);
		}

		[After]
		public function tearDown():void {
			instance = null;
		}

		[Test]
		public function can_be_instantiated():void {
			assertTrue("instance is TypeFilter", instance is TypeFilter);
		}
		
		[Test]
		public function implements_ITypeFilter_interface():void {
			assertTrue("instance implements ITypeFilter", instance is ITypeFilter);
		}

		[Test]
		public function test_failure_seen():void {
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function get_allOfTypes():void {
			assertEquals("Get allOfTypes", ALL_OF, instance.allOfTypes);
		}
		
		[Test]
		public function get_anyOfTypes():void {
			assertEquals("Get anyOfTypes", ANY_OF, instance.anyOfTypes);
		}
		
		[Test]
		public function get_noneOfTypes():void {
			assertEquals("Get noneOfTypes", NONE_OF, instance.noneOfTypes);
		}
		
		[Test (expects="ArgumentError")]
		public function initalising_with_allOf_null_throws_error():void {
			var nullFilter:TypeFilter = new TypeFilter(null, ANY_OF, NONE_OF);
		}
		
		[Test (expects="ArgumentError")]
		public function initalising_with_anyOf_null_throws_error():void {
			var nullFilter:TypeFilter = new TypeFilter(ALL_OF, null, NONE_OF);
		}
		
		[Test (expects="ArgumentError")]
		public function initalising_with_noneOf_null_throws_error():void {
			var nullFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, null);
		}
		
		[Test]
		public function get_descriptor_returns_alphabetised_readable_list():void {
			var expected:String = "all of: uint,Number, any of: flash.events::IEventDispatcher,flash.display::Sprite, none of: String,Error";
			assertEquals("Get descriptor returns alphabetised, readable list", expected, instance.descriptor);
		}
	}
}