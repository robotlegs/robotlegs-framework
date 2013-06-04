//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackCommand;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackCommand2;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackGuard;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackGuard2;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackHook;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.UnmapperStub;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;
	import robotlegs.bender.extensions.commandCenter.api.CommandPayload;

	public class CommandExecutorTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var unMapper:UnmapperStub;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mappings:Vector.<ICommandMapping>;

		private var subject:CommandExecutor;

		private var reported:Array;

		private var injector:IInjector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			reported = [];
			injector = new RobotlegsInjector();
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			mappings = new Vector.<ICommandMapping>();
			subject = new CommandExecutor(injector);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function oneShotMapping_is_removed():void
		{
			subject = new CommandExecutor(injector, unMapper.unmap);
			const mapping:ICommandMapping = addMapping(ClassReportingCallbackCommand);
			mapping.setFireOnce(true);

			subject.executeCommands(mappings);

			assertThat(unMapper, received().method('unmap').arg(mapping).once());
		}

		[Test]
		public function command_without_execute_method_is_still_constructed():void
		{
			addMapping(ExecutelessCommand).setExecuteMethod(null);

			subject.executeCommands(mappings);

			assertThat(reported, array(ExecutelessCommand));
		}

		[Test]
		public function command_is_executed():void
		{
			addMapping();
			executeCommands();
			assertThat(reported, array(ClassReportingCallbackCommand));
		}

		[Test]
		public function command_is_executed_repeatedly():void
		{
			addMappings(5);
			executeCommands();
			assertThat(reported.length, equalTo(5));
		}

		[Test]
		public function hooks_are_called():void
		{
			addMapping(NullCommand).addHooks(
				ClassReportingCallbackHook, ClassReportingCallbackHook, ClassReportingCallbackHook);
			executeCommands();
			assertThat(reported.length, equalTo(3));
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
			addMapping(SelfReportingCallbackCommand).addHooks(SelfReportingCallbackHook);
			executeCommands();
			assertThat(injectedCommand, equalTo(executedCommand));
		}

		[Test]
		public function command_executes_when_the_guard_allows():void
		{
			addMapping().addGuards(HappyGuard);
			executeCommands();
			assertThat(reported, array(ClassReportingCallbackCommand));
		}

		[Test]
		public function command_does_not_execute_when_any_guards_denies():void
		{
			addMapping().addGuards(HappyGuard, GrumpyGuard);
			executeCommands();
			assertThat(reported, array());
		}

		[Test]
		public function execution_sequence_is_guard_command_guard_command_with_multiple_mappings():void
		{
			addMapping(ClassReportingCallbackCommand).addGuards(ClassReportingCallbackGuard);
			addMapping(ClassReportingCallbackCommand2).addGuards(ClassReportingCallbackGuard2);
			executeCommands();
			assertThat(reported, array(
				ClassReportingCallbackGuard, ClassReportingCallbackCommand,
				ClassReportingCallbackGuard2, ClassReportingCallbackCommand2));
		}

		[Test]
		public function execution_sequence_is_guard_hook_command():void
		{
			addMapping().addGuards(ClassReportingCallbackGuard).addHooks(ClassReportingCallbackHook);
			executeCommands();
			assertThat(reported, array(
				ClassReportingCallbackGuard, ClassReportingCallbackHook, ClassReportingCallbackCommand));
		}

		[Test]
		public function allowed_commands_get_executed_after_denied_command():void
		{
			addMapping(ClassReportingCallbackCommand).addGuards(GrumpyGuard);
			addMapping(ClassReportingCallbackCommand2);
			executeCommands();
			assertThat(reported, array(ClassReportingCallbackCommand2));
		}

		[Test]
		public function command_with_different_method_than_execute_is_called():void
		{
			addMapping(ReportMethodCommand)
				.setExecuteMethod('report');

			executeCommands();

			assertThat(reported, array(ReportMethodCommand));
		}

		[Test(expects="Error")]
		public function throws_error_when_executeMethod_not_a_function():void
		{
			addMapping(IncorrectExecuteCommand);
			executeCommands();
			// note: no assertion. we just want to know if an error is thrown
		}

		[Test]
		public function payload_is_injected_into_command():void
		{
			addMapping(PayloadInjectionPointsCommand);
			const payload:CommandPayload = new CommandPayload(['message', 1], [String, int]);
			executeCommands(payload);
			assertThat(reported, array(payload.values));
		}

		[Test]
		public function payload_is_injected_into_hook():void
		{
			addMapping(NullCommand).addHooks(PayloadInjectionPointsHook);
			const payload:CommandPayload = new CommandPayload(['message', 1], [String, int]);
			executeCommands(payload);
			assertThat(reported, array(payload.values));
		}

		[Test]
		public function payload_is_injected_into_guard():void
		{
			addMapping(NullCommand).addGuards(PayloadInjectionPointsGuard);
			const payload:CommandPayload = new CommandPayload(['message', 1], [String, int]);
			executeCommands(payload);
			assertThat(reported, array(payload.values));
		}

		[Test]
		public function payload_is_passed_to_execute_method():void
		{
			addMapping(MethodParametersCommand);
			const payload:CommandPayload = new CommandPayload(['message', 1], [String, int]);
			executeCommands(payload);
			assertThat(reported, array(payload.values));
		}

		[Test]
		public function payloadInjection_is_disabled():void
		{
			addMapping(OptionalInjectionPointsCommand)
				.setPayloadInjectionEnabled(false);

			const payload:CommandPayload = new CommandPayload(['message', 1], [String, int]);
			executeCommands(payload);
			assertThat(reported, array(null, 0));
		}

		[Test]
		public function payload_doesnt_leak_into_class_instantiated_by_command():void
		{
			injector.map(IInjector).toValue(injector);
			addMapping(OptionalInjectionPointsCommandInstantiatingCommand);

			const payload:CommandPayload = new CommandPayload(['message', 1], [String, int]);
			executeCommands(payload);
			assertThat(reported, array(null, 0));
		}

		[Test]
		public function result_is_handled():void
		{
			const mapping:ICommandMapping = new CommandMapping(MessageReturningCommand);
			subject = new CommandExecutor(injector, null, resultReporter);
			injector.map(String).toValue('message');
			subject.executeCommand(mapping);
			assertThat(reported, array(hasProperties({
					result: 'message',
					command: instanceOf(MessageReturningCommand),
					mapping: mapping})))
		}

		[Test]
		public function uses_injector_mapped_command_instance():void
		{
			injector.map(Function, 'executeCallback').toValue(reportingFunction);
			injector.map(SelfReportingCallbackCommand).asSingleton();
			var expected:Object = injector.getInstance(SelfReportingCallbackCommand);
			var mapping:ICommandMapping = addMapping(SelfReportingCallbackCommand)
			subject.executeCommand(mapping);
			assertThat(reported, array(expected));
		}

		[Test]
		public function command_mapped_to_interface_is_executed():void
		{
			injector.map(ICommand).toType(AbstractInterfaceImplementingCommand);
			subject.executeCommand(addMapping(ICommand));
			assertThat(reported, array(AbstractInterfaceImplementingCommand));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addMapping(commandClass:Class = null):ICommandMapping
		{

			var mapping:ICommandMapping = new CommandMapping(commandClass || ClassReportingCallbackCommand);
			mappings.push(mapping);
			return mapping;
		}

		private function addMappings(totalEvents:uint = 1, commandClass:Class = null):void
		{
			while (totalEvents--)
			{
				addMapping(commandClass);
			}
		}

		private function executeCommands(payload:CommandPayload = null):void
		{
			subject.executeCommands(mappings, payload);
		}

		private function reportingFunction(item:Object):void
		{
			reported.push(item);
		}

		private function resultReporter(result:*, command:Object, mapping:ICommandMapping):void
		{
			reported.push({result: result, command: command, mapping: mapping});
		}
	}
}

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.api.IInjector;

class ExecutelessCommand
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
		reportingFunc(ExecutelessCommand);
	}
}

class ReportMethodCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function report():void
	{
		reportingFunc(ReportMethodCommand);
	}
}

class IncorrectExecuteCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var execute:String = 'execute';
}

class PayloadInjectionPointsCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var message:String;

	[Inject]
	public var code:int;

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc(message);
		reportingFunc(code);
	}
}

class MethodParametersCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute(message:String, code:int):void
	{
		reportingFunc(message);
		reportingFunc(code);
	}
}

class OptionalInjectionPointsCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	[Inject(optional=true)]
	public var message:String;

	[Inject(optional=true)]
	public var code:int;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc(message);
		reportingFunc(code);
	}
}

class MessageReturningCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var message:String;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():String
	{
		return message;
	}
}

class SelfReportingCallbackCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

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

class SelfReportingCallbackHook
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var command:SelfReportingCallbackCommand;

	[Inject(name="hookCallback")]
	public var callback:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
		callback(this);
	}
}

class PayloadInjectionPointsHook
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var message:String;

	[Inject]
	public var code:int;

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
		reportingFunc(message);
		reportingFunc(code);
	}
}

class PayloadInjectionPointsGuard
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var message:String;

	[Inject]
	public var code:int;

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		reportingFunc(message);
		reportingFunc(code);
		return true;
	}
}

class OptionalInjectionPointsCommandInstantiatingCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var injector:IInjector;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		var command:OptionalInjectionPointsCommand = injector.instantiateUnmapped(OptionalInjectionPointsCommand);
		command.execute();
	}
}

class AbstractInterfaceImplementingCommand implements ICommand
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
		reportingFunc(AbstractInterfaceImplementingCommand);
	}
}
