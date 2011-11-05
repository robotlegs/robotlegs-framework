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
		
		*/
		
		[Test]
		public function one_event_triggers_one_command_with_injection():void
		{
			after(Event.COMPLETE).execute(SimpleCommand);
			
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			const expectedCommands:Array = [SimpleCommand];
			assertEqualsArraysIgnoringOrder(commandTracker.commandsReceived, expectedCommands);
		}

		[Test]
		public function one_event_triggers_two_commands_in_order():void
		{
			after(Event.COMPLETE).executeAll(SimpleCommand, AnotherCommand);
			
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			const expectedCommands:Array = [SimpleCommand, AnotherCommand];
			assertThat(commandTracker.commandsReceived, array(expectedCommands));
		}
		
		[Test]
		public function two_different_events_trigger_different_commands():void
		{
			after(Event.COMPLETE).execute(SimpleCommand);
			after(Event.CHANGE).execute(AnotherCommand);
			
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			assertThat(commandTracker.commandsReceived, array([SimpleCommand]));
			
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertThat(commandTracker.commandsReceived, array([SimpleCommand, AnotherCommand]));
		}
		
		[Test]
		public function mapping_two_commands_to_same_event_separately_and_both_fire():void
		{
			after(Event.COMPLETE).execute(SimpleCommand);
			after(Event.COMPLETE).execute(AnotherCommand);
			
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			const expectedCommands:Array = [SimpleCommand, AnotherCommand];
			assertThat(commandTracker.commandsReceived, array(expectedCommands));
		}
		
		protected function after(eventString:String):CommandConfig
		{
			configsByEventString[eventString] ||= new CommandConfig();
			eventDispatcher.addEventListener(eventString, fireCommandsForEventString);
			return configsByEventString[eventString];
		}
		
		protected function fireCommandsForEventString(e:Event):void
		{
			const commandClassesForEvent:Vector.<Class> = configsByEventString[e.type].commandClasses;
			for each (var commandClass:Class in commandClassesForEvent)
			{
				const command:Object = injector.getInstance(commandClass);
				command.execute();
			}
		}
	}
}

import org.robotlegs.v2.core.utilities.pushValuesToClassVector;

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