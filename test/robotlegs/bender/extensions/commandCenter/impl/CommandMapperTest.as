//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
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
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand2;
	import robotlegs.bender.framework.api.ILogger;

	public class CommandMapperTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var trigger:ICommandTrigger;

		[Mock]
		public var logger:ILogger;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mapper:CommandMapper;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			mapper = new CommandMapper(trigger, logger);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function toCommand_registers_mappingConfig_with_trigger():void
		{
			const config:Object = mapper.toCommand(NullCommand);
			assertThat(trigger, received().method('addMapping').arg(config).once());
		}

		[Test]
		public function fromCommand_removes_mappingConfig_from_trigger():void
		{
			const oldConfig:Object = mapper.toCommand(NullCommand);
			mapper.fromCommand(NullCommand);
			assertThat(trigger, received().method('removeMapping').arg(oldConfig).once());
		}

		[Test]
		public function fromCommand_removes_only_specified_mappingConfig_from_trigger():void
		{
			const config1:Object = mapper.toCommand(NullCommand);
			const config2:Object = mapper.toCommand(NullCommand2);
			mapper.fromCommand(NullCommand);
			assertThat(trigger, received().method('removeMapping').arg(config1).once());
			assertThat(trigger, received().method('removeMapping').arg(config2).never());
		}

		[Test]
		public function fromAll_removes_all_mappingConfigs_from_trigger():void
		{
			const config1:Object = mapper.toCommand(NullCommand);
			const config2:Object = mapper.toCommand(NullCommand2);
			mapper.fromAll();
			assertThat(trigger, received().method('removeMapping').arg(config1).once());
			assertThat(trigger, received().method('removeMapping').arg(config2).once());
		}

		[Test]
		public function toCommand_unregisters_old_mappingConfig_and_registers_new_one_when_overwritten():void
		{
			const oldConfig:Object = mapper.toCommand(NullCommand);
			const newConfig:Object = mapper.toCommand(NullCommand);
			assertThat(trigger, received().method('removeMapping').arg(oldConfig).once());
			assertThat(trigger, received().method('addMapping').arg(newConfig).once());
		}

		[Test]
		public function toCommand_warns_when_overwritten():void
		{
			const oldConfig:Object = mapper.toCommand(NullCommand);
			mapper.toCommand(NullCommand);
			assertThat(logger, received().method('warn')
				.args(instanceOf(String), array(trigger, oldConfig)).once());
		}
	}
}
