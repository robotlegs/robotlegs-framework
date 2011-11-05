//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.events.EventDispatcher;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapper;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.support.CallbackCommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.support.NullCommand;
	import org.robotlegs.v2.extensions.commandMap.support.NullCommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.support.SupportEvent;
	import org.swiftsuspenders.Injector;

	public class CommandMapTests
	{
		private var commandMap:ICommandMap;

		private var injector:Injector;

		private var dispatcher:EventDispatcher;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			dispatcher = new EventDispatcher()
			commandMap = new CommandMap(injector, dispatcher);
		}

		[After]
		public function tearDown():void
		{
			injector = null;
			dispatcher = null;
			commandMap = null;
		}

		[Test]
		public function map_creates_mapper():void
		{
			const mapping:ICommandMapper = commandMap.map(NullCommand);
			assertThat(mapping, notNullValue());
		}

		[Test]
		public function map_to_trigger_stores_mapping():void
		{
			commandMap.map(NullCommand)
				.toTrigger(new NullCommandTrigger());
			assertThat(commandMap.hasMapping(NullCommand), isTrue());
		}

		[Test]
		public function map_to_event_stores_mapping():void
		{
			commandMap.map(NullCommand)
				.toEvent(SupportEvent.TYPE1);
			assertThat(commandMap.hasMapping(NullCommand), isTrue());
		}

		[Test]
		public function unmap_trigger_removes_mapping():void
		{
			const trigger:ICommandTrigger = new NullCommandTrigger();
			commandMap.map(NullCommand).toTrigger(trigger);
			commandMap.unmap(NullCommand).fromTrigger(trigger);
			assertThat(commandMap.hasMapping(NullCommand), isFalse());
		}

		[Test]
		public function unmap_event_removes_mapping():void
		{
			commandMap.map(NullCommand).toEvent(SupportEvent.TYPE1);
			commandMap.unmap(NullCommand).fromEvent(SupportEvent.TYPE1);
			assertThat(commandMap.hasMapping(NullCommand), isFalse());
		}

		[Test]
		public function unmap_many_removes_mapping():void
		{
			const trigger1:ICommandTrigger = new NullCommandTrigger();
			const trigger2:ICommandTrigger = new NullCommandTrigger();
			const trigger3:ICommandTrigger = new NullCommandTrigger();
			commandMap.map(NullCommand)
				.toTrigger(trigger1)
				.toTrigger(trigger2)
				.toTrigger(trigger3);
			commandMap.unmap(NullCommand)
				.fromTrigger(trigger1)
				.fromTrigger(trigger2)
				.fromTrigger(trigger3);
			assertThat(commandMap.hasMapping(NullCommand), isFalse());
		}

		[Test]
		public function unmapFromAll_removes_all_mappings():void
		{
			commandMap.map(NullCommand)
				.toTrigger(new NullCommandTrigger())
				.toTrigger(new NullCommandTrigger())
				.toTrigger(new NullCommandTrigger());
			commandMap.unmap(NullCommand).fromAll();
			assertThat(commandMap.hasMapping(NullCommand), isFalse());
		}

		[Test]
		public function map_trigger_is_registered():void
		{
			var registerCallCount:int;
			const trigger:ICommandTrigger = new CallbackCommandTrigger(
				function(mapping:ICommandMapping):void
				{
					registerCallCount++;
				});
			commandMap.map(NullCommand).toTrigger(trigger);
			assertThat(registerCallCount, equalTo(1));
		}

		[Test]
		public function unmap_trigger_is_unregistered():void
		{
			var unregisterCallCount:int;
			const trigger:ICommandTrigger = new CallbackCommandTrigger(
				null,
				function():void
				{
					unregisterCallCount++;
				});
			commandMap.map(NullCommand).toTrigger(trigger);
			commandMap.unmap(NullCommand).fromTrigger(trigger);
			assertThat(unregisterCallCount, equalTo(1));
		}

		[Test(expects="Error")]
		public function mapping_null_trigger_throws_error():void
		{
			commandMap.map(NullCommand).toTrigger(null);
		}
	}
}

