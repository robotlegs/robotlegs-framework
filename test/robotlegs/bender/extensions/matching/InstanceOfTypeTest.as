//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;

	public class InstanceOfTypeTest
	{

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function matches_type():void
		{
			assertThat(instanceOfType(Number).matches(5), isTrue());
		}

		[Test]
		public function does_not_match_wrong_type():void
		{
			assertThat(instanceOfType(String).matches(5), isFalse());
		}
	}
}
