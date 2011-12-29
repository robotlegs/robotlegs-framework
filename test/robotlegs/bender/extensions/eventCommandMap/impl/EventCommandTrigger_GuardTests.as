//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.commandMap.support.CallbackCommand;
	import robotlegs.bender.extensions.commandMap.support.NullCommand;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackGuard;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
	import robotlegs.bender.extensions.guards.support.GrumpyGuard;
	import robotlegs.bender.extensions.guards.support.HappyGuard;

	public class EventCommandTrigger_GuardTests extends AbstractEventCommandMapTests
	{

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
			eventCommandMap
				.map(SupportEvent.TYPE1)
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
			eventCommandMap
				.map(SupportEvent.TYPE1)
				.toCommand(CallbackCommand)
				.withGuards(guards);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			return executionCount;
		}
	}
}

