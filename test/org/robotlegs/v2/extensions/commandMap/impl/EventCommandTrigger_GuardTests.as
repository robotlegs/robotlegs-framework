//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.events.Event;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.extensions.commandMap.support.CallbackCommand;
	import org.robotlegs.v2.extensions.commandMap.support.NullCommand;
	import org.robotlegs.v2.extensions.commandMap.support.SelfReportingCallbackGuard;
	import org.robotlegs.v2.extensions.commandMap.support.SupportEvent;
	import org.robotlegs.v2.extensions.guards.support.GrumpyGuard;
	import org.robotlegs.v2.extensions.guards.support.HappyGuard;

	[Skip]
	public class EventCommandTrigger_GuardTests extends AbstractCommandMapTests
	{

		[Before]
		override public function setUp():void
		{
			super.setUp();
		}

		[After]
		override public function tearDown():void
		{
			super.tearDown();
		}

		[Test]
		public function command_executes_when_the_guard_allows():void
		{
			assertThat(commandExecutionCountWithGuards(HappyGuard), equalTo(1));
		}

		[Test]
		public function command_executes_when_all_guards_allow():void
		{
			assertThat(commandExecutionCountWithGuards(HappyGuard, HappyGuard), equalTo(1));
		}

		[Test]
		public function command_does_not_execute_when_the_guard_denies():void
		{
			assertThat(commandExecutionCountWithGuards(GrumpyGuard), equalTo(0));
		}

		[Test]
		public function command_does_not_execute_when_any_guards_denies():void
		{
			assertThat(commandExecutionCountWithGuards(HappyGuard, GrumpyGuard), equalTo(0));
		}

		[Test]
		public function command_does_not_execute_when_all_guards_deny():void
		{
			assertThat(commandExecutionCountWithGuards(GrumpyGuard, GrumpyGuard), equalTo(0));
		}

		[Test]
		public function event_is_injected_into_guard():void
		{
			var injectedEvent:Event;
			injector.map(Function, 'approveCallback').toValue(function(guard:SelfReportingCallbackGuard):void
			{
				injectedEvent = guard.event;
			});
			commandMap
				.mapEvent(SupportEvent.TYPE1)
				.toCommand(NullCommand)
				.withGuards(SelfReportingCallbackGuard);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
		}

		private function commandExecutionCountWithGuards(... guards):uint
		{
			var executionCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executionCount++;
			});
			commandMap
				.mapEvent(SupportEvent.TYPE1)
				.toCommand(CallbackCommand)
				.withGuards(guards);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			return executionCount;
		}
	}
}

