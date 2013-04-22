//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import flash.utils.getTimer;
	import org.hamcrest.assertThat;
	import org.hamcrest.number.lessThan;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;

	public class CommandExecutorStressTest
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TOTAL_ITERATIONS:uint = 50000;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var mappings:Vector.<ICommandMapping>;

		private var executor:CommandExecutor;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(async, timeout="250")]
		public function before():void
		{
			injector = new Injector();
			mappings = new Vector.<ICommandMapping>();
		}

		[After(async, timeout="250")]
		public function after():void
		{
			// cool down
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function command_not_mapped_to_injector_execution_speed_test():void
		{
			const executor:ICommandExecutor = new CommandExecutor(injector);
			createCommandMappingsList(CommandA, TOTAL_ITERATIONS);
			var start:int = getTimer();
			executor.executeCommands(mappings);
			var took:int = getTimer() - start;
			trace('command_not_mapped_to_injector_execution_speed_test', took); //2013-04-22: 749, 762, 807, 758
			assertThat(took, lessThan(1000));
		}

		[Test]
		public function command_mapped_to_injector_execution_speed_test():void
		{
			const executor:ICommandExecutor = new CommandExecutor(injector);
			injector.map(ICommand).toType(CommandA);
			createCommandMappingsList(ICommand, TOTAL_ITERATIONS);
			var start:int = getTimer();
			executor.executeCommands(mappings);
			var took:int = getTimer() - start;
			trace('command_mapped_to_injector_execution_speed_test', took); //2013-04-22: 836, 817, 820, 829
			assertThat(took, lessThan(1000));
		}

		[Test]
		public function command_mapped_to_root_injector_execution_speed_test():void
		{
			injector.map(ICommand).toType(CommandA);
			var i:int;
			var n:int = 10;
			var childInjector:Injector = injector;
			for (i = 0; i < n; i++)
			{
				childInjector = childInjector.createChildInjector();
			}
			const executor:ICommandExecutor = new CommandExecutor(childInjector);

			createCommandMappingsList(ICommand, TOTAL_ITERATIONS);
			var start:int = getTimer();
			executor.executeCommands(mappings);
			var took:int = getTimer() - start;
			trace('command_mapped_to_root_injector_execution_speed_test', took); //2013-04-22: 1678, 1980, 2071, 1650
			assertThat(took, lessThan(2200));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createCommandMappingsList(commandClass:Class, n:int = 1):void
		{
			var i:int;
			for (i = 0; i < n; i++)
			{
				var mapping:ICommandMapping = new CommandMapping(commandClass);
				mappings.push(mapping);
			}
		}
	}
}

import robotlegs.bender.extensions.commandCenter.api.ICommand;

internal class CommandA implements ICommand
{

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{

	}
}
