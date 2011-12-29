//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package suites
{
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMapTests;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger_BasicTests;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger_GuardTests;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger_HookTests;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class EventCommandMapTestSuite
	{
		public var eventCommandMapTests:EventCommandMapTests;

		public var eventCommandTriggerTests:EventCommandTrigger_BasicTests;

		public var eventCommandTriggerGuardTests:EventCommandTrigger_GuardTests;

		public var eventCommandTriggerHookTests:EventCommandTrigger_HookTests;
	}
}
