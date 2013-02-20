//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.hamcrest.Matcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;

	public class TypeMatcherTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const ALL_OF:Vector.<Class> = new <Class>[uint, Number];

		private const ALL_OF_2:Vector.<Class> = new <Class>[Object, IDataInput];

		private const ANY_OF:Vector.<Class> = new <Class>[Sprite, IEventDispatcher];

		private const ANY_OF_2:Vector.<Class> = new <Class>[DisplayObject, MovieClip];

		private const EMPTY_CLASS_VECTOR:Vector.<Class> = new <Class>[];

		private const NONE_OF:Vector.<Class> = new <Class>[ByteArray, String];

		private const NONE_OF_2:Vector.<Class> = new <Class>[ITypeFilter, ITypeMatcher];

		private var instance:TypeMatcher;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new TypeMatcher();
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
			assertThat(instance, instanceOf(TypeMatcher));
		}

		[Test]
		public function implements_ITypeMatcher():void
		{
			assertThat(instance, instanceOf(ITypeMatcher));
		}

		[Test]
		public function not_supplying_allOf_causes_no_errors():void
		{
			var expectedFilter:TypeFilter = new TypeFilter(new <Class>[], ANY_OF, NONE_OF);

			instance.anyOf(ANY_OF).noneOf(NONE_OF);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}

		[Test]
		public function not_supplying_anyOf_causes_no_errors():void
		{
			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, new <Class>[], NONE_OF);

			instance.allOf(ALL_OF).noneOf(NONE_OF);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}

		[Test]
		public function not_supplying_noneOf_causes_no_errors():void
		{
			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, new <Class>[]);

			instance.anyOf(ANY_OF).allOf(ALL_OF);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}

		[Test]
		public function supplying_all_any_and_none_in_different_order_populates_them_in_typeFilter():void
		{

			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, NONE_OF);

			instance.noneOf(NONE_OF).allOf(ALL_OF).anyOf(ANY_OF);

			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}

		[Test]
		public function supplying_all_any_and_none_populates_them_in_typeFilter():void
		{

			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, NONE_OF);

			instance.allOf(ALL_OF).anyOf(ANY_OF).noneOf(NONE_OF);

			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}

		[Test]
		public function supplying_multiple_all_values_includes_all_given_in_typeFilter():void
		{
			var expectedFilter:TypeFilter = new TypeFilter((ALL_OF.concat(ALL_OF_2)), ANY_OF, NONE_OF);

			instance.allOf(ALL_OF).anyOf(ANY_OF).noneOf(NONE_OF).allOf(ALL_OF_2);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}

		[Test]
		public function supplying_multiple_any_values_includes_all_given_in_typeFilter():void
		{

			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF.concat(ANY_OF_2), NONE_OF);

			instance.allOf(ALL_OF).anyOf(ANY_OF).noneOf(NONE_OF).anyOf(ANY_OF_2);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}

		[Test]
		public function supplying_multiple_none_values_includes_all_given_in_typeFilter():void
		{

			var expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, (NONE_OF.concat(NONE_OF_2)));

			instance.allOf(ALL_OF).anyOf(ANY_OF).noneOf(NONE_OF).noneOf(NONE_OF_2);
			assertMatchesTypeFilter(expectedFilter, instance.createTypeFilter());
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_allOf_changed_after_filter_requested():void
		{
			instance.anyOf(ANY_OF);
			instance.createTypeFilter();

			instance.allOf(ALL_OF);
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_allOf_changed_after_lock():void
		{
			instance.anyOf(ANY_OF);
			instance.lock();

			instance.allOf(ALL_OF);
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_anyOf_changed_after_filter_requested():void
		{
			instance.noneOf(NONE_OF);
			instance.createTypeFilter();

			instance.anyOf(ALL_OF);
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_anyOf_changed_after_lock():void
		{
			instance.noneOf(NONE_OF);
			instance.lock();

			instance.anyOf(ALL_OF);
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_noneOf_changed_after_filter_requested():void
		{
			instance.allOf(ALL_OF);
			instance.createTypeFilter();

			instance.noneOf(ALL_OF);
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_noneOf_changed_after_lock():void
		{
			instance.allOf(ALL_OF);
			instance.lock();

			instance.noneOf(ALL_OF);
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_conditions_empty_and_filter_requested():void
		{
			var emptyInstance:TypeMatcher = new TypeMatcher();
			emptyInstance.allOf(EMPTY_CLASS_VECTOR.slice()).anyOf(EMPTY_CLASS_VECTOR.slice()).noneOf(EMPTY_CLASS_VECTOR.slice());

			emptyInstance.createTypeFilter();
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_empty_and_filter_requested():void
		{
			const emptyInstance:TypeMatcher = new TypeMatcher();
			emptyInstance.createTypeFilter();
		}

		[Test]
		public function clone_returns_open_copy_when_not_locked():void
		{
			instance.allOf(ALL_OF).anyOf(ANY_OF);
			const clone:TypeMatcher = instance.clone();
			clone.noneOf(NONE_OF);
			const expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, NONE_OF);
			assertMatchesTypeFilter(expectedFilter, clone.createTypeFilter());
		}

		[Test]
		public function clone_returns_open_copy_when_locked():void
		{
			instance.allOf(ALL_OF).anyOf(ANY_OF);
			instance.lock();
			const clone:TypeMatcher = instance.clone();
			clone.noneOf(NONE_OF);
			const expectedFilter:TypeFilter = new TypeFilter(ALL_OF, ANY_OF, NONE_OF);
			assertMatchesTypeFilter(expectedFilter, clone.createTypeFilter());
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function assertMatchesTypeFilter(expected:ITypeFilter, actual:ITypeFilter):void
		{
			assertEqualsVectorsIgnoringOrder(expected.allOfTypes, actual.allOfTypes);
			assertEqualsVectorsIgnoringOrder(expected.anyOfTypes, actual.anyOfTypes);
			assertEqualsVectorsIgnoringOrder(expected.noneOfTypes, actual.noneOfTypes);
		}
	}
}
