//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.extensions.commandMap.impl.CommandMapTests;
	import org.robotlegs.v2.extensions.commandMap.impl.EventCommandTriggerTests;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class CommandMapTestSuite
	{
		public var commandMapTests:CommandMapTests;

		public var eventCommandTriggerTests:EventCommandTriggerTests;
	}
}
