//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandMap.api.ICommandMap;
	import robotlegs.bender.extensions.commandMap.impl.CommandMap;
	import robotlegs.bender.extensions.commandMap.support.CallbackCommand;
	import robotlegs.bender.extensions.commandMap.support.CallbackCommand2;
	import robotlegs.bender.extensions.commandMap.support.NullCommand;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackCommand;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackCommand2;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackHook;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.support.EventInjectedCallbackCommand;
	import robotlegs.bender.extensions.eventCommandMap.support.EventInjectedCallbackGuard;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
	import robotlegs.bender.framework.guard.support.GrumpyGuard;
	import robotlegs.bender.framework.guard.support.HappyGuard;

	public class EventCommandTriggerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var dispatcher:IEventDispatcher;

		private var commandMap:ICommandMap;

		private var eventCommandMap:IEventCommandMap;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			dispatcher = new EventDispatcher();
			commandMap = new CommandMap();
			eventCommandMap = new EventCommandMap(injector, dispatcher, commandMap);
		}

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
			injector.map(Function, 'executeCallback').toValue(function(command:EventInjectedCallbackCommand):void
			{
				injectedEvent = command.event;
			});
			eventCommandMap.map(SupportEvent.TYPE1)
				.toCommand(EventInjectedCallbackCommand);
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
			// note: no assertion. we just want to know if an error is thrown
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
			// note: no assertion. we just want to know if an error is thrown
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

		[Test]
		public function hooks_are_called():void
		{
			assertThat(hookCallCount(SelfReportingCallbackHook, SelfReportingCallbackHook), equalTo(2));
		}

		[Test]
		public function command_is_injected_into_hook():void
		{
			var executedCommand:SelfReportingCallbackCommand;
			var injectedCommand:SelfReportingCallbackCommand;
			injector.map(Function, 'executeCallback').toValue(function(command:SelfReportingCallbackCommand):void {
				executedCommand = command;
			});
			injector.map(Function, 'hookCallback').toValue(function(hook:SelfReportingCallbackHook):void {
				injectedCommand = hook.command;
			});
			eventCommandMap
				.map(SupportEvent.TYPE1)
				.toCommand(SelfReportingCallbackCommand)
				.withHooks(SelfReportingCallbackHook);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(injectedCommand, equalTo(executedCommand));
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
			injector.map(Function, 'approveCallback').toValue(function(guard:EventInjectedCallbackGuard):void
			{
				injectedEvent = guard.event;
			});
			eventCommandMap
				.map(SupportEvent.TYPE1)
				.toCommand(NullCommand)
				.withGuards(EventInjectedCallbackGuard);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
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

		private function hookCallCount(... hooks):uint
		{
			var hookCallCount:uint;
			injector.map(Function, 'executeCallback').toValue(function(command:SelfReportingCallbackCommand):void {
			});
			injector.map(Function, 'hookCallback').toValue(function(hook:SelfReportingCallbackHook):void {
				hookCallCount++;
			});
			eventCommandMap
				.map(SupportEvent.TYPE1)
				.toCommand(SelfReportingCallbackCommand)
				.withHooks(hooks);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			return hookCallCount;
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

import flash.events.Event;
import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;

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

