//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.support.CallbackCommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.support.NullCommand;
	import org.robotlegs.v2.extensions.commandMap.support.SupportEvent;

	public class CommandMapTests extends AbstractCommandMapTests
	{

		[Before]
		override public function setUp():void
		{
			super.setUp();
		}

		[After]
		override public function tearDown():void
		{
			super.tearDown();
		}

		[Test]
		public function mapTrigger_creates_mapper():void
		{
			assertThat(commandMap.mapTrigger(trigger), notNullValue());
		}

		[Test]
		public function mapEvent_creates_mapper():void
		{
			assertThat(commandMap.mapEvent(SupportEvent.TYPE1, SupportEvent), notNullValue());
		}

		[Test]
		public function mapTrigger_to_command_stores_mapping():void
		{
			commandMap.mapTrigger(trigger).toCommand(NullCommand);
			assertThat(commandMap.getTriggerMapping(trigger, NullCommand), notNullValue());
		}

		[Test]
		public function mapEvent_to_command_stores_mapping():void
		{
			commandMap.mapEvent(SupportEvent.TYPE1, SupportEvent).toCommand(NullCommand);
			assertThat(commandMap.getEventMapping(SupportEvent.TYPE1, SupportEvent, NullCommand), notNullValue());
		}

		[Test]
		public function unmapTrigger_from_command_removes_mapping():void
		{
			commandMap.mapTrigger(trigger).toCommand(NullCommand);
			commandMap.unmapTrigger(trigger).fromCommand(NullCommand)
			assertThat(commandMap.getTriggerMapping(trigger, NullCommand), nullValue());
		}

		[Test]
		public function unmapEvent_from_command_removes_mapping():void
		{
			commandMap.mapEvent(SupportEvent.TYPE1, SupportEvent).toCommand(NullCommand);
			commandMap.unmapEvent(SupportEvent.TYPE1, SupportEvent).fromCommand(NullCommand);
			assertThat(commandMap.getEventMapping(SupportEvent.TYPE1, SupportEvent, NullCommand), nullValue());
		}

		[Test]
		public function trigger_is_passed_mapping():void
		{
			var addedCount:uint;
			const trigger:ICommandTrigger = new CallbackCommandTrigger(
				function(mapping:ICommandMapping):void
				{
					addedCount++;
				});
			commandMap.mapTrigger(trigger).toCommand(NullCommand);
			assertThat(addedCount, equalTo(1));
		}

		[Test]
		public function trigger_is_passed_mapping_for_removal():void
		{
			var removedCount:uint;
			const trigger:ICommandTrigger = new CallbackCommandTrigger(
				null,
				function(mapping:ICommandMapping):void
				{
					removedCount++;
				});
			commandMap.mapTrigger(trigger).toCommand(NullCommand);
			commandMap.unmapTrigger(trigger).fromCommand(NullCommand);
			assertThat(removedCount, equalTo(1));
		}
	}
}

