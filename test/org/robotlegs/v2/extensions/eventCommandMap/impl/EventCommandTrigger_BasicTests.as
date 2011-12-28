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
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.extensions.commandMap.support.CallbackCommand;
	import org.robotlegs.v2.extensions.commandMap.support.CallbackCommand2;
	import org.robotlegs.v2.extensions.commandMap.support.SelfReportingCallbackCommand;
	import org.robotlegs.v2.extensions.commandMap.support.SelfReportingCallbackCommand2;
	import org.robotlegs.v2.extensions.eventCommandMap.support.SupportEvent;

	public class EventCommandTrigger_BasicTests extends AbstractEventCommandMapTests
	{

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

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
		public function specified_typed_event_is_injected_into_command():void
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
		public function unspecified_typed_event_is_injected_into_command():void
		{
			var injectedEvent:SupportEvent;
			injector.map(Function, 'executeCallback').toValue(function(command:SupportEventTriggeredSelfReportingCallbackCommand):void
			{
				injectedEvent = command.typedEvent;
			});
			eventCommandMap.map(SupportEvent.TYPE1)
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

		[Test]
		public function oneshot_mappings_should_not_bork_stacked_mappings():void
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent, true).toCommand(CallbackCommand);
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent, true).toCommand(CallbackCommand2);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(2));
		}

		[Test]
		public function one_shot_command_should_not_cause_infinite_loop_when_dispatching_to_self():void
		{
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			});
			eventCommandMap.map(SupportEvent.TYPE1, null, true).toCommand(CallbackCommand);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
		}

		[Test]
		public function commands_should_not_stomp_over_event_mappings():void
		{
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE2));
			});
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CallbackCommand);
			eventCommandMap.map(SupportEvent.TYPE2, null, true).toCommand(CallbackCommand);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
		}

		[Test]
		public function commands_are_executed_in_order():void
		{
			var commands:Array = [];
			injector.map(Function, 'executeCallback').toValue(function(command:Object):void
			{
				commands.push(command.toString());
			});
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(SelfReportingCallbackCommand);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(SelfReportingCallbackCommand2);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(commands, array("[object SelfReportingCallbackCommand]", "[object SelfReportingCallbackCommand2]"));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

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

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var event:Event;

	[Inject]
	public var typedEvent:SupportEvent;

	[Inject(name="executeCallback")]
	public var callback:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		callback(this);
	}
}

