//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackCommand;
	import robotlegs.bender.extensions.commandMap.support.SelfReportingCallbackHook;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;

	public class EventCommandTrigger_HookTest extends AbstractEventCommandMapTest
	{

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

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

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

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
	}
}

