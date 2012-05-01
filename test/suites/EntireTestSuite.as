//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import robotlegs.bender.core.CoreTestSuite;
	import robotlegs.bender.extensions.ExtensionsTestSuite;
	import robotlegs.bender.framework.FrameworkTestSuite;
	import robotlegs.bender.core.matching.TypeMatchingTestSuite;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class EntireTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var core:CoreTestSuite;

		public var framework:FrameworkTestSuite;

		public var extensions:ExtensionsTestSuite;
	
		public var typeMatcher:TypeMatchingTestSuite;
	}
}