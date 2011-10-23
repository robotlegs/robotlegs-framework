//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2
{
	import suites.ContextBuilderTestSuite;
	import suites.TypeMatchingTestSuite;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class Robotlegs2TestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var contextBuilderTestSuite:ContextBuilderTestSuite;

		public var typeMatchingTestSuite:TypeMatchingTestSuite;
	}
}
