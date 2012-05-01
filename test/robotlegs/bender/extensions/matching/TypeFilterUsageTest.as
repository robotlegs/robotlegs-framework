//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import org.flexunit.asserts.*;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.matching.support.*;

	public class TypeFilterUsageTest
	{

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function class_excluded_by_none():void
		{
			var subject:TypeB12 = new TypeB12();

			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[], new <Class>[TypeB]);

			assertFalse("Class excluded by none", filter.matches(subject));
		}

		[Test]
		public function class_matched_by_all():void
		{
			var subject:TypeA12 = new TypeA12();

			var filter:ITypeFilter = new TypeFilter(new <Class>[TypeA, IType1, IType2], new <Class>[], new <Class>[]);

			assertTrue("Class matched by all", filter.matches(subject));
		}

		[Test]
		public function class_matched_by_any():void
		{
			var subject:TypeB12 = new TypeB12();

			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[TypeA, IType1], new <Class>[]);

			assertTrue("Class matched by any", filter.matches(subject));
		}

		[Test]
		public function class_not_excluded_by_none():void
		{
			var subject:TypeA12 = new TypeA12();

			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[], new <Class>[TypeB]);

			assertTrue("Class not excluded by none", filter.matches(subject));
		}

		[Test]
		public function class_not_matched_by_all():void
		{
			var subject:TypeA1 = new TypeA1();

			var filter:ITypeFilter = new TypeFilter(new <Class>[TypeA, IType1, IType2], new <Class>[], new <Class>[]);

			assertFalse("Class not matched by all", filter.matches(subject));
		}

		[Test]
		public function class_not_matched_by_any():void
		{
			var subject:TypeB = new TypeB();

			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[TypeA, IType1], new <Class>[]);

			assertFalse("Class not matched by any", filter.matches(subject));
		}

		[Test]
		public function default_behaviour_where_nothing_is_specified():void
		{
			var subject:TypeB = new TypeB();

			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[], new <Class>[]);

			assertFalse("Default behaviour where nothing is specified is to not match", filter.matches(subject));
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Test failure", true);
		}
	}
}
