//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
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

	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommand;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommand2;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.SelfReportingCallbackCommand;
	import robotlegs.bender.extensions.commandCenter.support.SelfReportingCallbackCommand2;
	import robotlegs.bender.extensions.commandCenter.support.SelfReportingCallbackHook;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.support.CascadingCommand;
	import robotlegs.bender.extensions.eventCommandMap.support.EventInjectedCallbackCommand;
	import robotlegs.bender.extensions.eventCommandMap.support.EventInjectedCallbackGuard;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;

	public class EventCommandExecutorTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var dispatcher:IEventDispatcher;

		private var eventCommandMap:IEventCommandMap;

		private var reportedExecutions:Array;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			reportedExecutions = [];
			injector = new Injector();
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			dispatcher = new EventDispatcher();
			eventCommandMap = new EventCommandMap(injector, dispatcher, new CommandCenter());
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function command_without_execute_method_is_still_constructed():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandWithoutExecute);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(reportedExecutions, array(CommandWithoutExecute));
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
		public function fireOnce_command_executes_once():void
		{
			assertThat(oneshotCommandExecutionCount(5), equalTo(1));
		}

		[Test]
		public function event_is_injected_into_command():void
		{
			var injectedEvent:Event = null;
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
			var injectedEvent:SupportEvent = null;
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
			var injectedEvent:SupportEvent = null;
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
			var executeCount:uint = 0;
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
			var executeCount:uint = 0;
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
			var executeCount:uint = 0;
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
			var executeCount:uint = 0;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand).once();
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand2).once();
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
			eventCommandMap.map(SupportEvent.TYPE1, null).toCommand(CallbackCommand).once();
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
			eventCommandMap.map(SupportEvent.TYPE2, null).toCommand(CallbackCommand).once();
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
			var executedCommand:SelfReportingCallbackCommand = null;
			var injectedCommand:SelfReportingCallbackCommand = null;
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
			var injectedEvent:Event = null;
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

		[Test]
		public function cascading_events_do_not_throw_unmap_errors():void
		{
			injector.map(IEventDispatcher).toValue(dispatcher);
			injector.map(IEventCommandMap).toValue(eventCommandMap);
			eventCommandMap
				.map(CascadingCommand.EVENT_TYPE)
				.toCommand(CascadingCommand).once();
			dispatcher.dispatchEvent(new Event(CascadingCommand.EVENT_TYPE));
		}

		[Test]
		public function commands_mapped_to_dispatching_event_are_executed():void
		{
			injector.map(Function, 'reportingFunction').toValue(reportingFunction);
			injector.map(Class, 'nestedCommand').toValue(CommandA);
			injector.map(IEventCommandMap).toValue(eventCommandMap);
			eventCommandMap
				.map(CommandMappingCommand.EVENT_TYPE)
				.toCommand(CommandMappingCommand).once();
			dispatcher.dispatchEvent(new Event(CommandMappingCommand.EVENT_TYPE));
			assertThat( reportedExecutions, array( CommandA ) );
		}

		[Test]
		public function execution_sequence_is_guard_command_guard_command_for_multiple_mappings_to_same_event():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandA).withGuards(GuardA);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandB).withGuards(GuardB);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			const expectedOrder:Array = [GuardA, CommandA, GuardB, CommandB];
			assertThat(reportedExecutions, array(expectedOrder));
		}

		[Test]
		public function previously_constructed_command_does_not_slip_through_the_loop():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandA).withGuards(HappyGuard);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandB).withGuards(GrumpyGuard);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			const expectedOrder:Array = [CommandA];
			assertThat(reportedExecutions, array(expectedOrder));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function commandExecutionCount(totalEvents:int = 1, oneshot:Boolean = false):uint
		{
			var executeCount:uint = 0;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			eventCommandMap.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand).once(oneshot);
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
			var hookCallCount:uint = 0;
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
			var executionCount:uint = 0;
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

		private function reportingFunction(item:Object):void
		{
			reportedExecutions.push(item);
		}
	}
}

import flash.events.Event;
import flash.events.IEventDispatcher;

import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
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

class GuardA
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		reportingFunc && reportingFunc(GuardA);
		return true;
	}
}

class GuardB
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		reportingFunc && reportingFunc(GuardB);
		return true;
	}
}

class GuardC
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		reportingFunc && reportingFunc(GuardC);
		return true;
	}
}

class CommandA
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc && reportingFunc(CommandA);
	}
}

class CommandB
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc && reportingFunc(CommandB);
	}
}

class CommandWithoutExecute
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	[PostConstruct]
	public function init():void
	{
		reportingFunc(CommandWithoutExecute);
	}
}
class CommandMappingCommand{

	static public const EVENT_TYPE : String = 'EVENT_TYPE';

	[Inject(name="nestedCommand")]
	public var commandClass : Class;

	[Inject]
	public var eventCommandMap : IEventCommandMap;

	public function execute() : void{
		eventCommandMap.map( EVENT_TYPE )
			.toCommand( commandClass );
	}
}