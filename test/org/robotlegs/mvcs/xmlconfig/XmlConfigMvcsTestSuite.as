/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.mvcs.xmlconfig
{
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class XmlConfigMvcsTestSuite
	{
		public var commandMapTests:CommandMapTests;
		public var commandMapWithEventClassTests:CommandMapWithEventClassTests;
		public var mediatorMapTests:MediatorMapTests;
		public var commandTests:CommandTests;
		public var actorTests:ActorTests;
	}
}
