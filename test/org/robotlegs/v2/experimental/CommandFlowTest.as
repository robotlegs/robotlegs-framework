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
	

	public class CommandFlowTest 
	{
		private var instance:CommandFlow;
		private var eventDispatcher:EventDispatcher;
		private var commandTracker:CommandTracker;
		private var injector:Injector;
		private var commands:Vector.<Class>;

		[Before]
		public function setUp():void
		{
			instance = new CommandFlow();
			eventDispatcher = new EventDispatcher();
			commandTracker = new CommandTracker();
			injector = new Injector();
			injector.map(CommandTracker).toValue(commandTracker);
			
			commands = new <Class>[];
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			eventDispatcher = null;
			commandTracker = null;
			injector = null;
			commands = null;
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
		
		afterAll / afterAny
		execute
		executeAll
		withGuards
		withHooks
		
		*/
		
		[Test]
		public function one_event_triggers_one_command_with_injection():void
		{
			commands.push(SimpleCommand);
			eventDispatcher.addEventListener(Event.COMPLETE, fireCommandUsingInjection);
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			const expectedCommands:Array = [SimpleCommand];
			assertEqualsArraysIgnoringOrder(commandTracker.commandsReceived, expectedCommands);
		}

		[Test]
		public function one_event_triggers_two_commands_in_order():void
		{
			commands.push(SimpleCommand);
			commands.push(AnotherCommand);
			eventDispatcher.addEventListener(Event.COMPLETE, fireCommandUsingInjection);
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			const expectedCommands:Array = [SimpleCommand, AnotherCommand];
			assertThat(commandTracker.commandsReceived, array(expectedCommands));
		}
		
		protected function fireCommandUsingInjection(e:Event):void
		{
			for each (var commandClass:Class in commands)
			{
				const command:Object = injector.getInstance(commandClass);
				command.execute();
			}
		}		

	}
}

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