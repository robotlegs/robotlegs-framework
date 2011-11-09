//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.extensions.commandMap.support.CallbackCommand;
	import org.robotlegs.v2.extensions.commandMap.support.SelfReportingCallbackCommand;
	import org.robotlegs.v2.extensions.eventCommandMap.support.SupportEvent;

	public class EventCommandTrigger_BasicTests extends AbstractEventCommandMapTests
	{

		[Test(expects="Error")]
		public function mapping_nonCommandClass_to_event_should_throw_error():void
		{
			// NOTE: we do this here, not in the CommandMap itself
			// Some triggers don't require an execute() method
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(Object);
		}

		[Test]
		public function command_executes_successfully():void
		{
			assertThat(commandExecutionCount(1), equalTo(1));
		}

		[Test]
		public function command_executes_repeatedly():void
		{
			assertThat(commandExecutionCount(5), equalTo(5));
		}

		[Test]
		public function oneshot_command_executes_once():void
		{
			assertThat(oneshotCommandExecutionCount(5), equalTo(1));
		}

		[Test]
		public function event_is_injected_into_command():void
		{
			var injectedEvent:Event;
			injector.map(Function, 'executeCallback').toValue(function(command:SelfReportingCallbackCommand):void
			{
				injectedEvent = command.event;
			});
			eventCommandMap.map(SupportEvent.TYPE1)
				.toCommand(SelfReportingCallbackCommand);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
		}

		[Test]
		public function typed_event_is_injected_into_command():void
		{
			var injectedEvent:SupportEvent;
			injector.map(Function, 'executeCallback').toValue(function(command:SupportEventTriggeredSelfReportingCallbackCommand):void
			{
				injectedEvent = command.typedEvent;
			});
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent)
				.toCommand(SupportEventTriggeredSelfReportingCallbackCommand);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
		}

		[Test]
		public function command_does_not_execute_when_incorrect_eventType_dispatched():void
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CallbackCommand);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE2));
			assertThat(executeCount, equalTo(0));
		}

		[Test]
		public function command_does_not_execute_when_incorrect_eventClass_dispatched():void
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand);
			dispatcher.dispatchEvent(new Event(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(0));
		}

		[Test]
		public function command_does_not_execute_after_event_unmapped():void
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand);
			eventCommandMap.unmap(SupportEvent.TYPE1, SupportEvent).fromCommand(CallbackCommand);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(0));
		}

		private function commandExecutionCount(totalEvents:int = 1, oneshot:Boolean = false):uint
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent, oneshot).toCommand(CallbackCommand);
			while (totalEvents--)
			{
				dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			}
			return executeCount;
		}

		private function oneshotCommandExecutionCount(totalEvents:int = 1):uint
		{
			return commandExecutionCount(totalEvents, true);
		}
	}
}

import flash.events.Event;
import org.robotlegs.v2.extensions.eventCommandMap.support.SupportEvent;

class SupportEventTriggeredSelfReportingCallbackCommand
{

	[Inject]
	public var event:Event;

	[Inject]
	public var typedEvent:SupportEvent;

	[Inject(name="executeCallback")]
	public var callback:Function;

	public function execute():void
	{
		callback(this);
	}
}
