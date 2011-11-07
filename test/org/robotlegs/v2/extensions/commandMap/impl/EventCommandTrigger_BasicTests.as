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
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.support.CallbackCommand;
	import org.robotlegs.v2.extensions.commandMap.support.NullCommand;
	import org.robotlegs.v2.extensions.commandMap.support.SelfReportingCallbackCommand;
	import org.robotlegs.v2.extensions.commandMap.support.SupportEvent;

	public class EventCommandTrigger_BasicTests extends AbstractCommandMapTests
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

		[Test(expects="Error")]
		public function mapping_nonCommandClass_to_event_should_throw_error():void
		{
			// NOTE: we do this here, not in the CommandMap itself
			// Some triggers don't require an execute() method
			commandMap.map(Object).toEvent(SupportEvent.TYPE1);
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
			commandMap.map(SelfReportingCallbackCommand)
				.toEvent(SupportEvent.TYPE1);
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
			commandMap.map(SupportEventTriggeredSelfReportingCallbackCommand)
				.toEvent(SupportEvent.TYPE1, SupportEvent);
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
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1);
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
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1, SupportEvent);
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
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1, SupportEvent);
			commandMap.unmap(CallbackCommand).fromEvent(SupportEvent.TYPE1, SupportEvent);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(0));
		}

		[Test(expects="Error")]
		public function double_registration_should_throw():void
		{
			const mapping:ICommandMapping = new CommandMapping(injector, dispatcher, commandMap, NullCommand);
			const trigger:ICommandTrigger = new EventCommandTrigger(injector, dispatcher, "any", Event, false);
			trigger.register(mapping);
			trigger.register(mapping);
		}

		[Test(expects="Error")]
		public function nonRegistered_trigger_should_throw_when_unregistered():void
		{
			const trigger:ICommandTrigger = new EventCommandTrigger(injector, dispatcher, "any", Event, false);
			trigger.unregister();
		}

		private function commandExecutionCount(totalEvents:int = 1, oneshot:Boolean = false):uint
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1, SupportEvent, oneshot);
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
import org.robotlegs.v2.extensions.commandMap.support.SupportEvent;

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
