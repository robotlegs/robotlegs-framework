//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.extensions.commandMap.support.SelfReportingCallbackCommand;
	import org.robotlegs.v2.extensions.commandMap.support.SelfReportingCallbackHook;
	import org.robotlegs.v2.extensions.commandMap.support.SupportEvent;

	[Skip]
	public class EventCommandTrigger_HookTests extends AbstractCommandMapTests
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
		public function the_hook_is_called():void
		{
			assertThat(hookCallCount(SelfReportingCallbackHook), equalTo(1));
		}

		[Test]
		public function all_hooks_are_called():void
		{
			assertThat(hookCallCount(SelfReportingCallbackHook, SelfReportingCallbackHook), equalTo(2));
		}

		[Test]
		public function command_is_injected_into_hook():void
		{
			var executedCommand:SelfReportingCallbackCommand;
			var injectedCommand:SelfReportingCallbackCommand;
			injector.map(Function, 'executeCallback').toValue(function(command:SelfReportingCallbackCommand):void
			{
				executedCommand = command;
			});
			injector.map(Function, 'hookCallback').toValue(function(hook:SelfReportingCallbackHook):void
			{
				injectedCommand = hook.command;
			});
			commandMap
				.mapEvent(SupportEvent.TYPE1)
				.toCommand(SelfReportingCallbackCommand)
				.withHooks(SelfReportingCallbackHook);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(injectedCommand, equalTo(executedCommand));
		}

		private function hookCallCount(... hooks):uint
		{
			var hookCallCount:uint;
			injector.map(Function, 'executeCallback').toValue(function(command:SelfReportingCallbackCommand):void
			{
			});
			injector.map(Function, 'hookCallback').toValue(function(hook:SelfReportingCallbackHook):void
			{
				hookCallCount++;
			});
			commandMap
				.mapEvent(SupportEvent.TYPE1)
				.toCommand(SelfReportingCallbackCommand)
				.withHooks(hooks);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			return hookCallCount;
		}
	}
}

