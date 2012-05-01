//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import robotlegs.bender.extensions.matching.support.a.PackagedTypeA;
	import robotlegs.bender.extensions.matching.support.b.PackagedTypeB;
	import robotlegs.bender.extensions.matching.support.c.PackagedTypeC;

	public class PackageMatchingTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:PackageMatcher;

		private const PACKAGE_A:String = "robotlegs.bender.extensions.matching.support.a";

		private const PACKAGE_B:String = "robotlegs.bender.extensions.matching.support.b";

		private const PACKAGE_C:String = "robotlegs.bender.extensions.matching.support.c";

		private const PARENT_PACKAGE:String = "robotlegs.bender.extensions.matching.support";

		private const REQUIRE:String = PARENT_PACKAGE;

		private const REQUIRE_2:String = PACKAGE_A;

		private const ANY_OF:Vector.<String> = new <String>[PACKAGE_A, PACKAGE_B];

		private const ANY_OF_2:Vector.<String> = new <String>[PACKAGE_B, PACKAGE_C];

		private const EMPTY_VECTOR:Vector.<String> = new <String>[];

		private const NONE_OF:Vector.<String> = new <String>[PACKAGE_C];

		private const NONE_OF_2:Vector.<String> = new <String>[PACKAGE_B];

		private const ITEM_A:PackagedTypeA = new PackagedTypeA();

		private const ITEM_B:PackagedTypeB = new PackagedTypeB();

		private const ITEM_C:PackagedTypeC = new PackagedTypeC();

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new PackageMatcher();
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
			assertTrue("instance is PackageMatcher", instance is PackageMatcher);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test]
		public function implements_ITypeMatcher():void
		{
			assertTrue("Implements ITypeMatcher", instance is ITypeMatcher);
		}

		[Test]
		public function matches_based_on_anyOf():void
		{
			instance.anyOf(ANY_OF);
			const typeFilter:ITypeFilter = instance.createTypeFilter();
			assertTrue(typeFilter.matches(ITEM_A));
		}

		[Test]
		public function matches_based_on_noneOf():void
		{
			instance.noneOf(NONE_OF);
			const typeFilter:ITypeFilter = instance.createTypeFilter();
			assertTrue(typeFilter.matches(ITEM_B));
		}

		[Test]
		public function doesnt_match_based_on_noneOf():void
		{
			instance.noneOf(NONE_OF);
			const typeFilter:ITypeFilter = instance.createTypeFilter();
			assertFalse(typeFilter.matches(ITEM_C));
		}

		[Test]
		public function matches_based_on_noneOf_twice():void
		{
			instance.noneOf(NONE_OF);
			instance.noneOf(NONE_OF_2);
			const typeFilter:ITypeFilter = instance.createTypeFilter();
			assertFalse(typeFilter.matches(ITEM_B));
			assertFalse(typeFilter.matches(ITEM_C));
		}

		[Test]
		public function matches_based_on_anyOf_twice():void
		{
			instance.anyOf(ANY_OF);
			instance.anyOf(ANY_OF_2);
			const typeFilter:ITypeFilter = instance.createTypeFilter();
			assertTrue(typeFilter.matches(ITEM_A));
			assertTrue(typeFilter.matches(ITEM_B));
			assertTrue(typeFilter.matches(ITEM_C));
		}

		[Test]
		public function matches_subpackage_a_based_on_required():void
		{
			instance.require(REQUIRE);
			const typeFilter:ITypeFilter = instance.createTypeFilter();
			assertTrue(typeFilter.matches(ITEM_A));
		}

		[Test]
		public function matches_subpackage_b_based_on_required():void
		{
			instance.require(REQUIRE);
			const typeFilter:ITypeFilter = instance.createTypeFilter();
			assertTrue(typeFilter.matches(ITEM_B));
		}

		[Test]
		public function doesnt_match_subpackage_c_based_on_required_and_noneOf():void
		{
			instance.require(REQUIRE).noneOf(NONE_OF);
			const typeFilter:ITypeFilter = instance.createTypeFilter();
			assertFalse(typeFilter.matches(ITEM_C));
		}

		[Test(expects='flash.errors.IllegalOperationError')]
		public function throws_IllegalOperationError_if_require_changed_after_filter_requested():void
		{
			instance.anyOf(ANY_OF);
			instance.createTypeFilter();
			instance.require(REQUIRE);
		}

		[Test(expects='flash.errors.IllegalOperationError')]
		public function throws_IllegalOperationError_if_require_changed_after_lock():void
		{
			instance.anyOf(ANY_OF);
			instance.lock();
			instance.require(REQUIRE);
		}

		[Test(expects='flash.errors.IllegalOperationError')]
		public function throws_IllegalOperationError_if_anyOf_changed_after_filter_requested():void
		{
			instance.noneOf(NONE_OF);
			instance.createTypeFilter();
			instance.anyOf(ANY_OF);
		}

		[Test(expects='flash.errors.IllegalOperationError')]
		public function throws_IllegalOperationError_if_anyOf_changed_after_lock():void
		{
			instance.noneOf(NONE_OF);
			instance.lock();
			instance.anyOf(ANY_OF);
		}

		[Test(expects='flash.errors.IllegalOperationError')]
		public function throws_IllegalOperationError_if_noneOf_changed_after_filter_requested():void
		{
			instance.anyOf(ANY_OF);
			instance.createTypeFilter();
			instance.noneOf(NONE_OF);
		}

		[Test(expects='flash.errors.IllegalOperationError')]
		public function throws_IllegalOperationError_if_noneOf_changed_after_lock():void
		{
			instance.anyOf(ANY_OF);
			instance.lock();
			instance.noneOf(NONE_OF);
		}

		[Test(expects='flash.errors.IllegalOperationError')]
		public function throws_IllegalOperationError_if_require_called_twice():void
		{
			instance.require(REQUIRE);
			instance.require(REQUIRE_2);
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_conditions_empty_and_filter_requested():void
		{
			var emptyInstance:PackageMatcher = new PackageMatcher();
			emptyInstance.anyOf(new <String>[]).noneOf(new <String>[]);
			emptyInstance.createTypeFilter();
		}

		[Test(expects='robotlegs.bender.extensions.matching.TypeMatcherError')]
		public function throws_TypeMatcherError_if_empty_and_filter_requested():void
		{
			var emptyInstance:PackageMatcher = new PackageMatcher();
			emptyInstance.createTypeFilter();
		}
	}
}
