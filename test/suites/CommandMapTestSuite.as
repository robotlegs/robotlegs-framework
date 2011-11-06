//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.extensions.commandMap.impl.CommandMapTests;
	import org.robotlegs.v2.extensions.commandMap.impl.EventCommandTrigger_GuardTests;
	import org.robotlegs.v2.extensions.commandMap.impl.EventCommandTrigger_HookTests;
	import org.robotlegs.v2.extensions.commandMap.impl.EventCommandTrigger_BasicTests;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class CommandMapTestSuite
	{
		public var commandMapTests:CommandMapTests;

		public var eventCommandTriggerTests:EventCommandTrigger_BasicTests;

		public var eventCommandTriggerGuardTests:EventCommandTrigger_GuardTests;

		public var eventCommandTriggerHookTests:EventCommandTrigger_HookTests;
	}
}
