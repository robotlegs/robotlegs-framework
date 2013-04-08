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
	import mockolate.stub;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isTrue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.dsl.IOnceCommandConfig;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommand;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.PayloadReportingCommand;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.PinEvent;
	import robotlegs.bender.framework.impl.Context;

	/**
	 * @author creynder
	 */
	public class CommandCenterTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		private var subject:ICommandCenter;

		private var injector:Injector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			injector = context.injector;
			subject = new CommandCenter(context);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function configure_creates_ICommandConfig():void
		{
			assertThat(subject.configureCommand(NullCommand), instanceOf(IOnceCommandConfig));
		}

		[Test]
		public function executes_a_command_class():void
		{
			var isExecuted:Boolean = false;
			injector.map(Function, 'executeCallback').toValue(function():void {
				isExecuted = true;
			});

			subject.executeCommand(CallbackCommand);

			assertThat(isExecuted, isTrue());
		}

		[Test]
		public function executes_a_command_config():void
		{
			var isExecuted:Boolean = false;
			injector.map(Function, 'executeCallback').toValue(function():void {
				isExecuted = true;
			});

			subject.executeCommand(subject.configureCommand(CallbackCommand));

			assertThat(isExecuted, isTrue());
		}

		[Test]
		public function executes_command_classes():void
		{
			var executionCount:int = 0;
			injector.map(Function, 'executeCallback').toValue(function():void {
				executionCount++;
			});

			subject.executeCommands([CallbackCommand, CallbackCommand, CallbackCommand]);

			assertThat(executionCount, equalTo(3));
		}

		[Test]
		public function executes_command_configs():void
		{
			var executionCount:int = 0;
			injector.map(Function, 'executeCallback').toValue(function():void {
				executionCount++;
			});
			const config:IOnceCommandConfig = subject.configureCommand(CallbackCommand);

			subject.executeCommands([config, config, config]);

			assertThat(executionCount, equalTo(3));
		}

		[Test]
		public function executes_command_classes_and_configs_mixed():void
		{
			var executionCount:int = 0;
			injector.map(Function, 'executeCallback').toValue(function():void {
				executionCount++;
			});
			const config:IOnceCommandConfig = subject.configureCommand(CallbackCommand);

			subject.executeCommands([config, CallbackCommand, config, CallbackCommand]);

			assertThat(executionCount, equalTo(4));
		}

		[Test]
		public function injects_payload_into_command():void
		{
			const actual:Array = [];
			const expected:Array = ['string', 5];
			var payload:CommandPayload = new CommandPayload(expected, [String, int]);
			injector.map(Function, 'reportingFunction').toValue(function(passed:Object):void {
				actual.push(passed);
			});

			subject.executeCommand(PayloadReportingCommand, payload);

			assertThat(actual, array(expected));
		}

		[Test]
		public function injects_payload_into_commands():void
		{
			const actual:Array = [];
			const expected:Array = ['string', 5];
			var payload:CommandPayload = new CommandPayload(expected, [String, int]);
			injector.map(Function, 'reportingFunction').toValue(function(passed:Object):void {
				actual.push(passed);
			});

			subject.executeCommands([PayloadReportingCommand, PayloadReportingCommand], payload);

			assertThat(actual, array(expected.concat(expected)));
		}

		[Test]
		public function detains_command():void
		{
			const command:Object = {};
			var wasDetained:Boolean = false;
			var handler:Function = function(... params):void {
				wasDetained = true;
			}
			context.addEventListener(PinEvent.DETAIN, handler);

			subject.detain(command);

			assertThat(wasDetained, isTrue());
		}

		[Test]
		public function releases_command():void
		{
			const command:Object = {};
			var wasReleased:Boolean = false;
			var handler:Function = function(... params):void {
				wasReleased = true;
			}
			context.addEventListener(PinEvent.RELEASE, handler);
			subject.detain(command);

			subject.release(command);

			assertThat(wasReleased, isTrue());
		}
	}
}
