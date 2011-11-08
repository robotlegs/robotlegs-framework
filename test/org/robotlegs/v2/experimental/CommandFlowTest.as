//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental 
{
	import org.flexunit.asserts.*;
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import flash.events.EventDispatcher;
	import org.flexunit.asserts.assertEqualsArraysIgnoringOrder;
	import flash.events.Event;
	import org.swiftsuspenders.Injector;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.utilities.pushValuesToClassVector;
	import org.robotlegs.v2.experimental.CommandFlowStart;
	

	public class CommandFlowTest 
	{
		private var instance:CommandFlow;
		private var eventDispatcher:EventDispatcher;
		private var commandTracker:CommandTracker;
		private var injector:Injector;
		private var commands:Vector.<Class>;

		private var configsByEventString:Dictionary;

		[Before]
		public function setUp():void
		{
			instance = new CommandFlow();
			eventDispatcher = new EventDispatcher();
			commandTracker = new CommandTracker();
			injector = new Injector();
			injector.map(CommandTracker).toValue(commandTracker);
			
			instance.eventDispatcher = eventDispatcher;
			instance.injector = injector;
			
			commands = new <Class>[];
			
			configsByEventString = new Dictionary();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			eventDispatcher = null;
			commandTracker = null;
			injector = null;
			commands = null;
			configsByEventString = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is CommandFlow", instance is CommandFlow);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		/* API SKETCH:
		
		after / afterAll / afterAny
		execute
		executeAll
		withGuards
		withHooks
		initialize
		destroy
		reset
		
		*/
		
		[Test]
		public function start_events_arent_responded_to_until_flow_is_initialized():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(SimpleCommand);

			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			assertEquals(0, commandTracker.commandsReceived.length);
		}
		
		[Test]
		public function one_event_triggers_one_command_with_injection_from_START():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(SimpleCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			const expectedCommands:Array = [SimpleCommand];
			assertEqualsArraysIgnoringOrder(commandTracker.commandsReceived, expectedCommands);
		}


		[Test]
		public function one_event_triggers_two_commands_in_order_from_START():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).executeAll(SimpleCommand, AnotherCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			const expectedCommands:Array = [SimpleCommand, AnotherCommand];
			assertThat(commandTracker.commandsReceived, array(expectedCommands));
		}
		
		[Test]
		public function two_different_events_trigger_different_commands_from_START():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(SimpleCommand);
			instance.from(CommandFlowStart).after(Event.CHANGE).execute(AnotherCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			assertThat(commandTracker.commandsReceived, array([SimpleCommand]));
			
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertThat(commandTracker.commandsReceived, array([SimpleCommand, AnotherCommand]));
		}
		
		[Test]
		public function mapping_two_commands_to_same_event_separately_and_both_fire_from_START():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(SimpleCommand);
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(AnotherCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			const expectedCommands:Array = [SimpleCommand, AnotherCommand];
			assertThat(commandTracker.commandsReceived, array(expectedCommands));
		}
		
		[Test]
		public function afterAny_either_event_triggers_command_from_START_1():void
		{
			instance.from(CommandFlowStart).afterAny(Event.COMPLETE, Event.CHANGE).execute(SimpleCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			assertThat(commandTracker.commandsReceived, array([SimpleCommand]));
		}
		
		[Test]
		public function afterAny_either_event_triggers_command_from_START_2():void
		{	
			instance.from(CommandFlowStart).afterAny(Event.COMPLETE, Event.CHANGE).execute(SimpleCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertThat(commandTracker.commandsReceived, array([SimpleCommand]));
		}
		

		[Test]
		public function afterAll_one_event_does_NOT_trigger_command_from_START():void
		{
			instance.from(CommandFlowStart).afterAll(Event.COMPLETE, Event.CHANGE).execute(SimpleCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			assertThat(commandTracker.commandsReceived, array([]));
		}

		[Test]
		public function afterAll_other_event_does_NOT_trigger_command_from_START():void
		{
			instance.from(CommandFlowStart).afterAll(Event.COMPLETE, Event.CHANGE).execute(SimpleCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertThat(commandTracker.commandsReceived, array([]));
		}

		[Test]
		public function afterAll_both_events_trigger_command_from_START():void
		{
			instance.from(CommandFlowStart).afterAll(Event.COMPLETE, Event.CHANGE).execute(SimpleCommand);
			instance.initialize();

			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));

			assertThat(commandTracker.commandsReceived, array([SimpleCommand]));
		}
	}
}

import org.robotlegs.v2.core.utilities.pushValuesToClassVector;
import flash.utils.Dictionary;

class CommandTracker
{
	private var _commandsReceived:Array = [];
	
	public function get commandsReceived():Array
	{
		return _commandsReceived;
	}
	
	public function notify(command:Object):void
	{
		_commandsReceived.push(command);
	}
	
	public function reset():void
	{
		_commandsReceived = [];
	}
}

class SimpleCommand
{
	[Inject]
	public var commandTracker:CommandTracker;
	
	public function execute():void
	{
		commandTracker.notify(SimpleCommand);
	}
}

class AnotherCommand
{
	[Inject]
	public var commandTracker:CommandTracker;
	
	public function execute():void
	{
		commandTracker.notify(AnotherCommand);
	}
}

class CommandConfig
{
	private const _commandClasses:Vector.<Class> = new <Class>[];
	
	public function get commandClasses():Vector.<Class>
	{
		return _commandClasses;
	}
	
	public function execute(commandClass:Class):void
	{
		_commandClasses.push(commandClass);
	}
	
	public function executeAll(...commandClassList):void
	{
		pushValuesToClassVector(commandClassList, _commandClasses);
	}
}