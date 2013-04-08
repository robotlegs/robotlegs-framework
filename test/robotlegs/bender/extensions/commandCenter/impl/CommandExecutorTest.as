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
	import robotlegs.bender.extensions.commandCenter.support.UnmapperStub;

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

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addMapping(commandClass:Class):ICommandMapping
		{
			const mapping:ICommandMapping = new CommandMapping(commandClass);
			mappings.push(mapping);
			return mapping;
		}

		private function commandExecutionCount(totalEvents:int = 1, oneshot:Boolean = false):uint
		{
			const mapping:ICommandMapping = addMapping(CommandA);
			mapping.setFireOnce(oneshot);
			while (totalEvents--)
			{
				subject.execute(mappings);
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

