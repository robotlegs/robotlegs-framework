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
	import org.swiftsuspenders.Injector;

	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.UnmapperStub;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;

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

		private var injector:Injector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			reported = [];
			injector = new Injector();
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			mappings = new Vector.<ICommandMapping>();
			subject = new CommandExecutor(injector, unMapper.unmap);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function oneShotMapping_is_removed():void
		{
			const mapping:ICommandMapping = addMapping(CommandA);
			mapping.setFireOnce(true);

			subject.execute(mappings);

			assertThat(unMapper, received().method('unmap').arg(mapping).once());
		}

		[Test]
		public function command_is_constructed():void
		{
			addMapping(CommandWithoutExecute)
				.setExecuteMethod(null);

			subject.execute(mappings);

			assertThat(reported, array(CommandWithoutExecute));
		}

		[Test]
		public function test_command_is_executed():void
		{
			addMapping();

			executeCommands();

			assertThat(reported, array(CommandA));
		}

		[Test]
		public function test_command_is_executed_repeatedly():void
		{
			addMappings(5);

			executeCommands();

			assertThat(reported.length, equalTo(5));
		}

		[Test]
		public function test_hooks_are_called():void
		{
			addMapping(NullCommand)
				.addHooks(HookA, HookA, HookA);

			executeCommands();

			assertThat(reported.length, equalTo(3));
		}

		[Test]
		public function test_command_executes_when_the_guard_allows():void
		{
			addMapping()
				.addGuards(HappyGuard);

			executeCommands();

			assertThat(reported, array(CommandA));
		}

		[Test]
		public function test_command_does_not_execute_when_any_guards_denies():void
		{
			addMapping()
				.addGuards(HappyGuard, GrumpyGuard);

			executeCommands();

			assertThat(reported, array());
		}

		[Test]
		public function test_execution_sequence_is_guard_command_guard_command_with_multiple_mappings():void
		{
			addMapping(CommandA)
				.addGuards(GuardA);
			addMapping(CommandB)
				.addGuards(GuardB);

			executeCommands();

			assertThat(reported, array(
				GuardA,
				CommandA,
				GuardB,
				CommandB));
		}

		[Test]
		public function test_execution_sequence_is_guard_hook_command():void
		{
			addMapping()
				.addGuards(GuardA)
				.addHooks(HookA);

			executeCommands();

			assertThat(reported, array(
				GuardA,
				HookA,
				CommandA));
		}

		[Test]
		public function test_allowed_commands_get_executed_after_denied_command():void
		{
			addMapping(CommandA)
				.addGuards(GrumpyGuard);
			addMapping(CommandB);

			executeCommands();

			assertThat(reported, array(CommandB));
		}

		[Test]
		public function test_command_with_different_method_than_execute_is_called():void
		{
			addMapping(CommandWithReportMethodInsteadOfExecute)
				.setExecuteMethod('report');

			executeCommands();

			assertThat(reported, array(CommandWithReportMethodInsteadOfExecute));
		}

		[Test(expects="Error")]
		public function test_throws_error_when_executeMethod_not_a_function():void
		{
			addMapping(CommandWithIncorrectExecute);

			executeCommands();

			// note: no assertion. we just want to know if an error is thrown
		}

		[Test]
		public function test_payload_is_injected_into_command():void
		{
			addMapping(CommandWithPayload);
			const payload:CommandPayload = new CommandPayload(['message', 0],[String, int]);

			executeCommands( payload );

			assertThat(reported, array(payload.values));
		}

		[Test]
		public function test_payload_is_passed_to_execute_method():void
		{
			addMapping(CommandWithMethodParameters);
			const payload:CommandPayload = new CommandPayload(['message', 0],[String, int]);

			executeCommands(payload);

			assertThat(reported, array(payload.values));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addMapping(commandClass:Class = null):ICommandMapping
		{

			var mapping:ICommandMapping = new CommandMapping(commandClass || CommandA);
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
			subject.execute(mappings, payload);
		}

		private function reportingFunction(item:Object):void
		{
			reported.push(item);
		}
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

class CommandWithReportMethodInsteadOfExecute
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
		reportingFunc(CommandWithReportMethodInsteadOfExecute);
	}
}

class CommandWithIncorrectExecute
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var execute:String = 'execute';
}

class CommandWithPayload
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

class CommandWithMethodParameters
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
		return true
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
		return true
	}
}

class HookA
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
		reportingFunc && reportingFunc(HookA);
	}
}
