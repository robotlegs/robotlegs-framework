//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import mockolate.mock;
	import mockolate.nice;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.support.CommandMapStub;

	public class CommandExecutorTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(type="strict")]
		public var host:CommandMapStub;

		[Mock]
		public var trigger:ICommandTrigger;

		[Mock]
		public var mappings:CommandMappingList;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:CommandExecutor;

		private var reportedExecutions:Array;

		private var injector:Injector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			reportedExecutions = [];
			injector = new Injector();
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			mappings = new CommandMappingList(trigger);
			subject = new CommandExecutor(mappings, injector);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function payloadMapper_is_passed_mapping():void
		{
			const mapping:CommandMapping = new CommandMapping(CommandA);
			mock(host).method("hook").args(mapping).once();
			mappings.addMapping(mapping);
			subject.withPayloadMapper(host.hook);
			subject.execute();
		}

		[Test]
		public function payloadUnmapper_is_passed_mapping():void
		{
			const mapping:CommandMapping = new CommandMapping(CommandA);
			mock(host).method("hook").args(mapping).once();
			mappings.addMapping(mapping);
			subject.withPayloadUnmapper(host.hook);
			subject.execute();
		}

		[Test]
		public function oneShotMapping_is_removed():void
		{
			const mapping:CommandMapping = new CommandMapping(CommandA);
			mapping.setFireOnce(true);
			mappings = nice(CommandMappingList);
			mappings.addMapping(mapping);
			mock(mappings).method("removeMapping").args(mapping).once();
			subject.execute();
			subject.execute();
		}

		[Test]
		public function command_is_constructed():void
		{
			const mapping:CommandMapping = new CommandMapping(CommandWithoutExecute);
			mapping.setExecuteMethod(null);
			mappings.addMapping(mapping);
			subject.execute();
			assertThat(reportedExecutions, array(CommandWithoutExecute));
		}

		[Test]
		public function command_is_executed():void
		{
			assertThat(commandExecutionCount(), equalTo(1));
		}

		[Test]
		public function command_is_executed_repeatedly():void
		{
			assertThat(commandExecutionCount(5), equalTo(5));
		}

		[Test]
		public function fireOnce_command_executes_once():void
		{
			assertThat(commandExecutionCount(5, true), equalTo(1));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function commandExecutionCount(totalEvents:int = 1, oneshot:Boolean = false):uint
		{
			const mapping:CommandMapping = new CommandMapping(CommandA);
			mapping.setFireOnce(oneshot);
			mappings.addMapping(mapping);
			while (totalEvents--)
			{
				subject.execute();
			}
			var interestingExecutionCount:int = 0;
			for each (var item:Object in reportedExecutions)
			{
				if (item == CommandA)
					interestingExecutionCount++;
			}
			return interestingExecutionCount;
		}

		private function reportingFunction(item:Object):void
		{
			reportedExecutions.push(item);
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
