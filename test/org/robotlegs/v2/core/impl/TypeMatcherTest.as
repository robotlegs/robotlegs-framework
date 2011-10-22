package org.robotlegs.v2.core.impl {

	import asunit.framework.TestCase;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import flash.display.DisplayObject;
	import flash.utils.IDataInput;
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import flash.events.IEventDispatcher;
	import asunit.errors.AssertionFailedError;
	import flash.display.Sprite;
	import org.robotlegs.v2.core.impl.TypeMatcherError;
	import flash.errors.IllegalOperationError;

	public class TypeMatcherTest extends TestCase {
		private var instance:TypeMatcher;

		private const ALL_OF:Vector.<Class> = new <Class>[uint, Number];
		private const ANY_OF:Vector.<Class>	= new <Class>[Sprite, IEventDispatcher];
		private const NONE_OF:Vector.<Class> = new <Class>[String, Error];

		private const ALL_OF_2:Vector.<Class> = new <Class>[Object, IDataInput];
		private const ANY_OF_2:Vector.<Class>	= new <Class>[DisplayObject, MovieClip];
		private const NONE_OF_2:Vector.<Class> = new <Class>[ByteArray];

		private const EMPTY_CLASS_VECTOR:Vector.<Class> = new <Class>[];
		
		public function TypeMatcherTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new TypeMatcher();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is TypeMatcher", instance is TypeMatcher);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_implements_ITypeMatcher():void {
			assertTrue("Implements ITypeMatcher", instance is ITypeMatcher);
		}
		
		public function test_supplying_all_any_and_none_populates_them_in_typeFilter():void {
			
			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, NONE_OF);
			
			instance.allOf(ALL_OF).anyOf(ANY_OF).noneOf(NONE_OF);
			
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}
		
		public function test_supplying_all_any_and_none_in_different_order_populates_them_in_typeFilter():void {
			
			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, NONE_OF);
			
			instance.noneOf(NONE_OF).allOf(ALL_OF).anyOf(ANY_OF);
			
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}
		
		public function test_supplying_mulitple_all_values_includes_all_given_in_typeFilter():void {
			var expectedFilter:TypeFilter = new TypeFilter((ALL_OF.concat(ALL_OF_2)), ANY_OF, NONE_OF);
			
			instance.allOf(ALL_OF).anyOf(ANY_OF).noneOf(NONE_OF).allOf(ALL_OF_2);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}
		
		public function test_supplying_mulitple_any_values_includes_all_given_in_typeFilter():void {
			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF.concat(ANY_OF_2), NONE_OF);
			
			instance.allOf(ALL_OF).anyOf(ANY_OF).noneOf(NONE_OF).anyOf(ANY_OF_2);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}
		
		public function test_supplying_mulitple_none_values_includes_all_given_in_typeFilter():void {
			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, (NONE_OF.concat(NONE_OF_2)));
			
			instance.allOf(ALL_OF).anyOf(ANY_OF).noneOf(NONE_OF).noneOf(NONE_OF_2);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}
		
		public function test_not_supplying_allOf_causes_no_errors():void {
			var expectedFilter:TypeFilter = new TypeFilter(new <Class>[], ANY_OF, NONE_OF);
			
			instance.anyOf(ANY_OF).noneOf(NONE_OF);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}
		
		public function test_not_supplying_anyOf_causes_no_errors():void {
			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, new <Class>[], NONE_OF);
			
			instance.allOf(ALL_OF).noneOf(NONE_OF);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}
		
		public function test_not_supplying_noneOf_causes_no_errors():void {
			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, new <Class>[]);
			
			instance.anyOf(ANY_OF).allOf(ALL_OF);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}
		
		public function test_throws_TypeMatcherError_if_empty_and_filter_requested():void {
			var emptyInstance:TypeMatcher = new TypeMatcher();
			assertThrows(TypeMatcherError, function():void{ emptyInstance.createTypeFilter() }); 
		}
		
		public function test_throws_TypeMatcherError_if_conditions_empty_and_filter_requested():void {
			var emptyInstance:TypeMatcher = new TypeMatcher();
			emptyInstance.allOf(EMPTY_CLASS_VECTOR.slice()).anyOf(EMPTY_CLASS_VECTOR.slice()).noneOf(EMPTY_CLASS_VECTOR.slice());
			
			assertThrows(TypeMatcherError, function():void{ emptyInstance.createTypeFilter() }); 
		}
		
		protected function assertMatchesTypeFilter(expected:ITypeFilter, actual:ITypeFilter):void
		{
			try {
				assertEqualsVectorsIgnoringOrder(expected.allOfTypes, actual.allOfTypes);
				assertEqualsVectorsIgnoringOrder(expected.anyOfTypes, actual.anyOfTypes);
				assertEqualsVectorsIgnoringOrder(expected.noneOfTypes, actual.noneOfTypes);
			}
			catch(assertionFailedError:AssertionFailedError) {
				getResult().addFailure(this, assertionFailedError);
			}
		}
		
		public function test_throws_IllegalOperationError_if_allOf_changed_after_filter_requested():void {
			instance.anyOf(ANY_OF);
			instance.createTypeFilter();
		
			assertThrows(IllegalOperationError, function():void { instance.allOf(ALL_OF) });
		}
		
		public function test_throws_IllegalOperationError_if_anyOf_changed_after_filter_requested():void {
			instance.noneOf(NONE_OF);
			instance.createTypeFilter();
		
			assertThrows(IllegalOperationError, function():void { instance.anyOf(ALL_OF) });
		}
		
		public function test_throws_IllegalOperationError_if_noneOf_changed_after_filter_requested():void {
			instance.allOf(ALL_OF);
			instance.createTypeFilter();
		
			assertThrows(IllegalOperationError, function():void { instance.noneOf(ALL_OF) });
		}
		
		public function test_throws_IllegalOperationError_if_allOf_changed_after_lock():void {
			instance.anyOf(ANY_OF);
			instance.lock();
		
			assertThrows(IllegalOperationError, function():void { instance.allOf(ALL_OF) });
		}
		
		public function test_throws_IllegalOperationError_if_anyOf_changed_after_lock():void {
			instance.noneOf(NONE_OF);
			instance.lock();
		
			assertThrows(IllegalOperationError, function():void { instance.anyOf(ALL_OF) });
		}
		
		public function test_throws_IllegalOperationError_if_noneOf_changed_after_lock():void {
			instance.allOf(ALL_OF);
			instance.lock();
		
			assertThrows(IllegalOperationError, function():void { instance.noneOf(ALL_OF) });
		}
		
		
	}
}