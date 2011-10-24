//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.utilities.hooks.HookBaseTest;
	import org.robotlegs.v2.utilities.hooks.HookUtilityMapTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class HooksTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var hookBaseTest:HookBaseTest;
		
		public var hookUtilityMap:HookUtilityMapTest;
	}
}