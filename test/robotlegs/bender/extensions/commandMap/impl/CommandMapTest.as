//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandMap.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.extensions.commandMap.api.ICommandMap;
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.extensions.commandMap.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandMap.support.CallbackCommandTrigger;
	import robotlegs.bender.extensions.commandMap.support.NullCommand;
	import robotlegs.bender.extensions.commandMap.support.NullCommandTrigger;
	import org.swiftsuspenders.Injector;

	public class CommandMapTest
	{

		protected var commandMap:ICommandMap;

		protected var injector:Injector;

		protected var trigger:ICommandTrigger;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			commandMap = new CommandMap();
			trigger = new NullCommandTrigger(injector);
		}

		[After]
		public function tearDown():void
		{
			injector = null;
			commandMap = null;
			trigger = null;
		}

		[Test]
		public function mapTrigger_creates_mapper():void
		{
			assertThat(commandMap.map(trigger), notNullValue());
		}

		[Test]
		public function mapTrigger_to_command_stores_mapping():void
		{
			commandMap.map(trigger).toCommand(NullCommand);
			assertThat(commandMap.getMapping(trigger).forCommand(NullCommand), notNullValue());
		}

		[Test]
		public function unmapTrigger_from_command_removes_mapping():void
		{
			commandMap.map(trigger).toCommand(NullCommand);
			commandMap.unmap(trigger).fromCommand(NullCommand)
			assertThat(commandMap.getMapping(trigger).forCommand(NullCommand), nullValue());
		}

		[Test]
		public function trigger_is_passed_mapping():void
		{
			var addedCount:uint;
			const trigger:ICommandTrigger = new CallbackCommandTrigger(
				injector,
				function(mapping:ICommandMapping):void
				{
					addedCount++;
				});
			commandMap.map(trigger).toCommand(NullCommand);
			assertThat(addedCount, equalTo(1));
		}

		[Test]
		public function trigger_is_passed_mapping_for_removal():void
		{
			var removedCount:uint;
			const trigger:ICommandTrigger = new CallbackCommandTrigger(
				injector,
				null,
				function(mapping:ICommandMapping):void
				{
					removedCount++;
				});
			commandMap.map(trigger).toCommand(NullCommand);
			commandMap.unmap(trigger).fromCommand(NullCommand);
			assertThat(removedCount, equalTo(1));
		}
	}
}

