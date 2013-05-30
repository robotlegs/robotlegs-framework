//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.directCommandMap.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.strictlyEqualTo;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommand;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommand2;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.directCommandMap.api.IDirectCommandMap;
	import robotlegs.bender.extensions.directCommandMap.dsl.IDirectCommandConfigurator;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.PinEvent;
	import robotlegs.bender.framework.impl.Context;

	public class DirectCommandMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		private var subject:DirectCommandMap;

		private var injector:IInjector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			injector = context.injector;
			injector.map(IDirectCommandMap).toType(DirectCommandMap);
			subject = injector.getInstance(IDirectCommandMap);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function map_creates_IOnceCommandConfig():void
		{
			assertThat(subject.map(NullCommand), instanceOf(IDirectCommandConfigurator));
		}

		[Test]
		public function successfully_executes_command_classes():void
		{
			var executionCount:int = 0;
			injector.map(Function, 'executeCallback').toValue(function():void {
				executionCount++;
			});

			subject.map(CallbackCommand)
				.map(CallbackCommand2)
				.execute();

			assertThat(executionCount, equalTo(2));
		}

		[Test]
		public function commands_get_injected_with_DirectCommandMap_instance():void
		{
			var actual:IDirectCommandMap;
			injector.map(Function, 'reportingFunction').toValue(function(passed:IDirectCommandMap):void {
				actual = passed;
			});

			subject.map(DirectCommandMapReportingCommand).execute();

			assertThat(actual, strictlyEqualTo(subject));
		}

		[Test]
		public function commands_are_disposed_after_execution():void
		{
			var executionCount:int = 0;
			injector.map(Function, 'executeCallback').toValue(function():void {
				executionCount++;
			});

			subject.map(CallbackCommand).execute();
			subject.map(CallbackCommand).execute();

			assertThat(executionCount, equalTo(2));
		}

		[Test]
		public function sandboxed_directCommandMap_instance_does_not_leak_into_system():void
		{
			var actual:IDirectCommandMap = injector.getInstance(IDirectCommandMap);

			assertThat(actual, not(equalTo(subject)));
		}

		[Test]
		public function detains_command():void
		{
			const command:Object = {};
			var wasDetained:Boolean = false;
			var handler:Function = function(... params):void {
				wasDetained = true;
			};
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
			};
			context.addEventListener(PinEvent.RELEASE, handler);
			subject.detain(command);

			subject.release(command);

			assertThat(wasReleased, isTrue());
		}

		[Test]
		public function executes_command():void
		{
			var executionCount:int = 0;
			injector.map(Function, 'executeCallback').toValue(function():void {
				executionCount++;
			});

			subject.map(CallbackCommand);
			subject.execute();

			assertThat(executionCount, equalTo(1));
		}

		[Test]
		public function mapping_processor_is_called():void
		{
			var callCount:int = 0;
			subject.addMappingProcessor(function(mapping:ICommandMapping):void {
				callCount++;
			});
			subject.map(NullCommand);
			assertThat(callCount, equalTo(1));
		}
	}
}

import robotlegs.bender.extensions.directCommandMap.api.IDirectCommandMap;

internal class DirectCommandMapReportingCommand
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var dcm:IDirectCommandMap;

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc(dcm);
	}
}
