/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.mvcs
{
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class MvcsTestSuite
	{
		public var mediatorProtectedTests:MediatorProtectedTests;
		public var commandTests:CommandTests;
		public var contextTests:ContextTests;
		public var actorTests:ActorTests;
		public var actorProtectedTests:ActorProtectedTests;
	}
}
