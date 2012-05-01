//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import org.flexunit.asserts.*;
	import robotlegs.bender.extensions.matching.PackageFilter;

	public class PackageFilter_descriptorTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const REQUIRE:String = "k.j";

		private const ANY_OF:Vector.<String> = new <String>["b.c.d", "a.b.c"];

		private const EMPTY_VECTOR:Vector.<String> = new <String>[];

		private const NONE_OF:Vector.<String> = new <String>["f.g.h", "c.d.e"];

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			const instance:PackageFilter = new PackageFilter(REQUIRE, EMPTY_VECTOR, EMPTY_VECTOR);
			assertTrue("instance is PackageFilter", instance is PackageFilter);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test]
		public function descriptor_produced_as_alphabetised_readable_list():void
		{
			const filter:PackageFilter = new PackageFilter(REQUIRE, ANY_OF, NONE_OF);
			var expected:String = "require: k.j, any of: a.b.c,b.c.d, none of: c.d.e,f.g.h";
			assertEquals(expected, filter.descriptor);
		}
	}
}
