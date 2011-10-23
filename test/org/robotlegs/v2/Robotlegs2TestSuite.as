/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.v2
{
	import suites.ContextBuilderTestSuite;
	import suites.TypeMatchingTestSuite;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class Robotlegs2TestSuite
	{
		public var contextBuilderTestSuite:ContextBuilderTestSuite;
		public var typeMatchingTestSuite:TypeMatchingTestSuite;
	}
}