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
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommand;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommand2;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackCommand;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackCommand2;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackGuard;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackGuard2;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackHook;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.support.CascadingCommand;
	import robotlegs.bender.extensions.eventCommandMap.support.EventInjectedCallbackCommand;
	import robotlegs.bender.extensions.eventCommandMap.support.EventInjectedCallbackGuard;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;

	public class EventCommandMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:IEventCommandMap;

		private var mapper:ICommandMapper;

		private var reportedExecutions:Array;

		private var injector:IInjector;

		private var dispatcher:IEventDispatcher;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			reportedExecutions = [];
			const context:IContext = new Context();
			injector = context.injector;
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			dispatcher = new EventDispatcher();
			subject = new EventCommandMap(context, dispatcher);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function map_creates_mapper():void
		{
			assertThat(subject.map(SupportEvent.TYPE1, SupportEvent), instanceOf(ICommandMapper));
		}

		[Test]
		public function map_to_identical_Type_but_different_Event_returns_different_mapper():void
		{
			mapper = subject.map(SupportEvent.TYPE1, SupportEvent);
			assertThat(subject.map(SupportEvent.TYPE1, Event), not(equalTo(mapper)));
		}

		[Test]
		public function map_to_different_Type_but_identical_Event_returns_different_mapper():void
		{
			mapper = subject.map(SupportEvent.TYPE1, SupportEvent);
			assertThat(subject.map(SupportEvent.TYPE2, SupportEvent), not(equalTo(mapper)));
		}

		[Test]
		public function unmap_returns_mapper():void
		{
			mapper = subject.map(SupportEvent.TYPE1, SupportEvent);
			assertThat(subject.unmap(SupportEvent.TYPE1, SupportEvent), instanceOf(ICommandUnmapper));
		}

		[Test]
		public function robust_to_unmapping_non_existent_mappings():void
		{
			subject.unmap(SupportEvent.TYPE1).fromCommand(NullCommand);
			// note: no assertion, just testing for the lack of an NPE
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
			subject.map(SupportEvent.TYPE1, Event)
				.toCommand(EventInjectedCallbackCommand);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
		}

		[Test]
		public function event_is_passed_to_execute_method():void
		{
			var actualEvent:SupportEvent;
			injector.map(Function, 'executeCallback').toValue(function(event:SupportEvent):void
			{
				actualEvent = event;
			});
			subject.map(SupportEvent.TYPE1, SupportEvent)
				.toCommand(EventParametersCommand);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(actualEvent, equalTo(event));
		}

		[Test]
		public function concretely_specified_typed_event_is_injected_into_command_as_typed_event():void
		{
			var injectedEvent:SupportEvent = null;
			injector.map(Function, 'executeCallback').toValue(function(command:SupportEventTriggeredSelfReportingCallbackCommand):void
			{
				injectedEvent = command.typedEvent;
			});
			subject.map(SupportEvent.TYPE1, SupportEvent)
				.toCommand(SupportEventTriggeredSelfReportingCallbackCommand);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
		}

		[Test]
		public function abstractly_specified_typed_event_is_injected_into_command_as_untyped_event():void
		{
			var injectedEvent:Event = null;
			injector.map(Function, 'executeCallback').toValue(function(command:SupportEventTriggeredSelfReportingCallbackCommand):void
			{
				injectedEvent = command.untypedEvent;
			});
			subject.map(SupportEvent.TYPE1, Event)
				.toCommand(SupportEventTriggeredSelfReportingCallbackCommand);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
		}

		[Test]
		public function unspecified_typed_event_is_injected_into_command_as_typed_event():void
		{
			var injectedEvent:SupportEvent = null;
			injector.map(Function, 'executeCallback').toValue(function(command:SupportEventTriggeredSelfReportingCallbackCommand):void
			{
				injectedEvent = command.typedEvent;
			});
			subject.map(SupportEvent.TYPE1)
				.toCommand(SupportEventTriggeredSelfReportingCallbackCommand);
			const event:SupportEvent = new SupportEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
		}

		[Test]
		public function unspecified_untyped_event_is_injected_into_command_as_untyped_event():void
		{
			const eventType:String = 'eventType';
			var injectedEvent:Event = null;
			injector.map(Function, 'executeCallback').toValue(function(command:SupportEventTriggeredSelfReportingCallbackCommand):void
			{
				injectedEvent = command.untypedEvent;
			});
			subject.map(eventType)
				.toCommand(SupportEventTriggeredSelfReportingCallbackCommand);
			const event:Event = new Event(eventType);
			dispatcher.dispatchEvent(event);
			assertThat(injectedEvent, equalTo(event));
		}

		[Test]
		public function specified_untyped_event_is_injected_into_command_as_untyped_event():void
		{
			const eventType:String = 'eventType';
			var injectedEvent:Event = null;
			injector.map(Function, 'executeCallback').toValue(function(command:SupportEventTriggeredSelfReportingCallbackCommand):void
			{
				injectedEvent = command.untypedEvent;
			});
			subject.map(eventType, Event)
				.toCommand(SupportEventTriggeredSelfReportingCallbackCommand);
			const event:Event = new Event(eventType);
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
			subject.map(SupportEvent.TYPE1).toCommand(CallbackCommand);
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
			subject.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand);
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
			subject.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand);
			subject.unmap(SupportEvent.TYPE1, SupportEvent).fromCommand(CallbackCommand);
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
			subject.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand).once();
			subject.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand2).once();
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
			subject.map(SupportEvent.TYPE1, null).toCommand(CallbackCommand).once();
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
			subject.map(SupportEvent.TYPE1).toCommand(CallbackCommand);
			subject.map(SupportEvent.TYPE2, null).toCommand(CallbackCommand).once();
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			// note: no assertion. we just want to know if an error is thrown
		}

		[Test]
		public function commands_are_executed_in_order():void
		{
			subject.map(SupportEvent.TYPE1).toCommand(ClassReportingCallbackCommand);
			subject.map(SupportEvent.TYPE1).toCommand(ClassReportingCallbackCommand2);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(reportedExecutions, array(ClassReportingCallbackCommand, ClassReportingCallbackCommand2));
		}

		[Test]
		public function hooks_are_called():void
		{
			assertThat(hookCallCount(ClassReportingCallbackHook, ClassReportingCallbackHook), equalTo(2));
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
			subject
				.map(SupportEvent.TYPE1, Event)
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
			injector.map(IEventCommandMap).toValue(subject);
			subject
				.map(CascadingCommand.EVENT_TYPE)
				.toCommand(CascadingCommand).once();
			dispatcher.dispatchEvent(new Event(CascadingCommand.EVENT_TYPE));
		}

		[Test]
		public function execution_sequence_is_guard_command_guard_command_for_multiple_mappings_to_same_event():void
		{
			subject.map(SupportEvent.TYPE1).toCommand(ClassReportingCallbackCommand).withGuards(ClassReportingCallbackGuard);
			subject.map(SupportEvent.TYPE1).toCommand(ClassReportingCallbackCommand2).withGuards(ClassReportingCallbackGuard2);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			const expectedOrder:Array = [ClassReportingCallbackGuard, ClassReportingCallbackCommand, ClassReportingCallbackGuard2, ClassReportingCallbackCommand2];
			assertThat(reportedExecutions, array(expectedOrder));
		}

		[Test]
		public function previously_constructed_command_does_not_slip_through_the_loop():void
		{
			subject.map(SupportEvent.TYPE1).toCommand(ClassReportingCallbackCommand).withGuards(HappyGuard);
			subject.map(SupportEvent.TYPE1).toCommand(ClassReportingCallbackCommand2).withGuards(GrumpyGuard);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			const expectedOrder:Array = [ClassReportingCallbackCommand];
			assertThat(reportedExecutions, array(expectedOrder));
		}

		[Test]
		public function commands_mapped_during_execution_are_not_executed():void
		{
			injector.map(IEventCommandMap).toValue(subject);
			injector.map(Class, 'nestedCommand').toValue(ClassReportingCallbackCommand);
			subject.map(SupportEvent.TYPE1, Event)
				.toCommand(CommandMappingCommand).once();
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(reportedExecutions, array());
		}

		[Test]
		public function commands_unmapped_during_execution_are_still_executed():void
		{
			injector.map(IEventCommandMap).toValue(subject);
			injector.map(Class, 'nestedCommand').toValue(ClassReportingCallbackCommand);
			subject.map(SupportEvent.TYPE1, Event)
				.toCommand(CommandUnmappingCommand).once();
			subject.map(SupportEvent.TYPE1, Event)
				.toCommand(ClassReportingCallbackCommand).once();
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(reportedExecutions, array(ClassReportingCallbackCommand));
		}

		[Test]
		public function mapping_processor_is_called():void
		{
			var callCount:int = 0;
			subject.addMappingProcessor(function(mapping:ICommandMapping):void {
				callCount++;
			});
			subject.map("type").toCommand(NullCommand);
			assertThat(callCount, equalTo(1));
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
			subject.map(SupportEvent.TYPE1, SupportEvent).toCommand(CallbackCommand).once(oneshot);
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
			injector.unmap(Function, 'reportingFunction');
			injector.map(Function, 'reportingFunction').toValue(function(hookClas:Class):void {
				hookCallCount++;
			});
			subject
				.map(SupportEvent.TYPE1)
				.toCommand(NullCommand)
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
			subject
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
import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackHook;
import robotlegs.bender.extensions.commandCenter.support.NullCommand;
import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;

class SupportEventTriggeredSelfReportingCallbackCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(optional=true)]
	public var untypedEvent:Event;

	[Inject(optional=true)]
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

class EventParametersCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="executeCallback")]
	public var callback:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute(event:SupportEvent):void
	{
		callback(event);
	}
}

class CommandMappingCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var event:Event;

	[Inject(name="nestedCommand")]
	public var commandClass:Class;

	[Inject]
	public var eventCommandMap:IEventCommandMap;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		eventCommandMap.map(event.type, Event).toCommand(commandClass);
	}
}

class CommandUnmappingCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var event:Event;

	[Inject(name="nestedCommand")]
	public var commandClass:Class;

	[Inject]
	public var eventCommandMap:IEventCommandMap;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		eventCommandMap.unmap(event.type, Event).fromCommand(commandClass);
	}
}
