//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.support.CallbackCommandTrigger;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.NullCommandTrigger;

	public class CommandCenterTest
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var commandCenter:ICommandCenter;

		protected var injector:Injector;

		protected var trigger:ICommandTrigger;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			commandCenter = new CommandCenter();
			trigger = new NullCommandTrigger(injector);
		}

		[After]
		public function after():void
		{
			injector = null;
			commandCenter = null;
			trigger = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function mapTrigger_creates_mapper():void
		{
			assertThat(commandCenter.map(trigger), notNullValue());
		}

		[Test]
		public function mapTrigger_to_command_stores_mapping():void
		{
			commandCenter.map(trigger).toCommand(NullCommand);
			assertThat(commandCenter.getMapping(trigger).forCommand(NullCommand), notNullValue());
		}

		[Test]
		public function unmapTrigger_from_command_removes_mapping():void
		{
			commandCenter.map(trigger).toCommand(NullCommand);
			commandCenter.unmap(trigger).fromCommand(NullCommand);
			assertThat(commandCenter.getMapping(trigger).forCommand(NullCommand), nullValue());
		}

		[Test]
		public function trigger_is_passed_mapping():void
		{
			var addedCount:uint = 0;
			const trigger:ICommandTrigger = new CallbackCommandTrigger(
				injector,
				function(mapping:ICommandMapping):void
				{
					addedCount++;
				});
			commandCenter.map(trigger).toCommand(NullCommand);
			assertThat(addedCount, equalTo(1));
		}

		[Test]
		public function trigger_is_passed_mapping_for_removal():void
		{
			var removedCount:uint = 0;
			const trigger:ICommandTrigger = new CallbackCommandTrigger(
				injector,
				null,
				function(mapping:ICommandMapping):void
				{
					removedCount++;
				});
			commandCenter.map(trigger).toCommand(NullCommand);
			commandCenter.unmap(trigger).fromCommand(NullCommand);
			assertThat(removedCount, equalTo(1));
		}
	}
}

