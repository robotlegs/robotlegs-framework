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
		public var commandMapTests:XmlCommandMapTests;
		public var commandMapWithEventClassTests:XmlCommandMapWithEventClassTests;
		public var mediatorMapTests:XmlMediatorMapTests;
		public var commandTests:XmlCommandTests;
		public var actorTests:XmlActorTests;
	}
}
