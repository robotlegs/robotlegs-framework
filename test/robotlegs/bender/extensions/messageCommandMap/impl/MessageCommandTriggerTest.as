//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap.impl
{
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IMessageDispatcher;
	import robotlegs.bender.framework.impl.MessageDispatcher;
	import robotlegs.bender.extensions.commandMap.api.ICommandMap;
	import robotlegs.bender.extensions.commandMap.impl.CommandMap;
	import robotlegs.bender.extensions.commandMap.support.CallbackCommand;
	import robotlegs.bender.extensions.commandMap.support.CallbackCommand2;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackCommand;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackCommand2;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackHook;
	import robotlegs.bender.extensions.messageCommandMap.api.IMessageCommandMap;
	import robotlegs.bender.extensions.messageCommandMap.support.CallbackConsumingCommand;
	import robotlegs.bender.extensions.messageCommandMap.support.SupportMessage;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;

	public class MessageCommandTriggerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var dispatcher:IMessageDispatcher;

		private var commandMap:ICommandMap;

		private var messageCommandMap:IMessageCommandMap;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			dispatcher = new MessageDispatcher();
			commandMap = new CommandMap();
			messageCommandMap = new MessageCommandMap(injector, dispatcher, commandMap);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(expects="Error")]
		public function mapping_nonCommandClass_should_throw_error():void
		{
			// NOTE: we do this here, not in the CommandMap itself
			// Some triggers don't require an execute() method
			messageCommandMap.map(SupportMessage).toCommand(Object);
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
		public function command_does_not_execute_when_incorrect_message_dispatched():void
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			messageCommandMap.map(SupportMessage).toCommand(CallbackCommand);
			dispatcher.dispatchMessage(Sprite);
			assertThat(executeCount, equalTo(0));
		}

		[Test]
		public function command_does_not_execute_after_message_unmapped():void
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			messageCommandMap.map(SupportMessage).toCommand(CallbackCommand);
			messageCommandMap.unmap(SupportMessage).fromCommand(CallbackCommand);
			dispatcher.dispatchMessage(SupportMessage);
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
			messageCommandMap.map(SupportMessage, true).toCommand(CallbackCommand);
			messageCommandMap.map(SupportMessage, true).toCommand(CallbackCommand2);
			dispatcher.dispatchMessage(SupportMessage);
			assertThat(executeCount, equalTo(2));
		}

		[Test]
		public function one_shot_command_should_not_cause_infinite_loop_when_dispatching_to_self():void
		{
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				dispatcher.dispatchMessage(SupportMessage);
			});
			messageCommandMap.map(SupportMessage, true).toCommand(CallbackCommand);
			dispatcher.dispatchMessage(SupportMessage);
			// note: no assertion. we just want to know if an error is thrown
		}

		[Test]
		public function commands_should_not_stomp_over_message_mappings():void
		{
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				dispatcher.dispatchMessage(Sprite);
			});
			messageCommandMap.map(SupportMessage).toCommand(CallbackCommand);
			messageCommandMap.map(Sprite, true).toCommand(CallbackCommand);
			dispatcher.dispatchMessage(SupportMessage);
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
			messageCommandMap.map(SupportMessage).toCommand(SelfReportingCallbackCommand);
			messageCommandMap.map(SupportMessage).toCommand(SelfReportingCallbackCommand2);
			dispatcher.dispatchMessage(SupportMessage);
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
			messageCommandMap
				.map(SupportMessage)
				.toCommand(SelfReportingCallbackCommand)
				.withHooks(SelfReportingCallbackHook);
			dispatcher.dispatchMessage(SupportMessage);
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
		public function command_that_consumes_callback_halts_processing():void
		{
			var callCount:int = 0;
			injector.map(Function, 'executeCallback').toValue(function():void {
				callCount++;
			});
			messageCommandMap.map(SupportMessage).toCommand(CallbackConsumingCommand);
			messageCommandMap.map(SupportMessage).toCommand(CallbackCommand);
			dispatcher.dispatchMessage(SupportMessage);
			assertThat(callCount, equalTo(0));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function commandExecutionCount(totalMessages:int = 1, oneshot:Boolean = false):uint
		{
			var executeCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executeCount++;
			});
			messageCommandMap.map(SupportMessage, oneshot).toCommand(CallbackCommand);
			while (totalMessages--)
			{
				dispatcher.dispatchMessage(SupportMessage);
			}
			return executeCount;
		}

		private function oneshotCommandExecutionCount(totalMessages:int = 1):uint
		{
			return commandExecutionCount(totalMessages, true);
		}

		private function hookCallCount(... hooks):uint
		{
			var hookCallCount:uint;
			injector.map(Function, 'executeCallback').toValue(function(command:SelfReportingCallbackCommand):void {
			});
			injector.map(Function, 'hookCallback').toValue(function(hook:SelfReportingCallbackHook):void {
				hookCallCount++;
			});
			messageCommandMap
				.map(SupportMessage)
				.toCommand(SelfReportingCallbackCommand)
				.withHooks(hooks);
			dispatcher.dispatchMessage(SupportMessage);
			return hookCallCount;
		}

		private function commandExecutionCountWithGuards(... guards):uint
		{
			var executionCount:uint;
			injector.map(Function, 'executeCallback').toValue(function():void
			{
				executionCount++;
			});
			messageCommandMap
				.map(SupportMessage)
				.toCommand(CallbackCommand)
				.withGuards(guards);
			dispatcher.dispatchMessage(SupportMessage);
			return executionCount;
		}
	}
}
