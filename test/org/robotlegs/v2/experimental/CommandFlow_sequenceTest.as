//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.flexunit.asserts.*;
	import org.flexunit.asserts.assertEqualsArraysIgnoringOrder;
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.robotlegs.v2.core.utilities.pushValuesToClassVector;
	import org.robotlegs.v2.experimental.CommandFlow;
	import org.robotlegs.v2.experimental.CommandFlowStart;
	import org.swiftsuspenders.Injector;

	public class CommandFlow_sequenceTest 
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
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function two_commands_in_sequence_second_event_doesnt_trigger_command_initially():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(CommandA);
			instance.from(CommandA).after(Event.CHANGE).execute(CommandB);
			
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertEquals(0, commandTracker.commandsReceived.length);
		}
		
		[Test]
		public function two_commands_in_sequence_first_command_fires_after_first_event():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(CommandA);
			instance.from(CommandA).after(Event.CHANGE).execute(CommandB);
			
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			assertThat(commandTracker.commandsReceived, array(CommandA));
		}

		[Test]
		public function two_commands_in_sequence_first_command_doesnt_fire_twice():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(CommandA);
			instance.from(CommandA).after(Event.CHANGE).execute(CommandB);
			
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			assertThat(commandTracker.commandsReceived, array(CommandA));
		}
		
		[Test]
		public function two_commands_in_sequence_both_commands_have_fired_after_both_events_firing():void
		{
			instance.from(CommandFlowStart).after(Event.COMPLETE).execute(CommandA);
			instance.from(CommandA).after(Event.CHANGE).execute(CommandB);
			
			eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
			eventDispatcher.dispatchEvent(new Event(Event.CHANGE));
			assertThat(commandTracker.commandsReceived, array(CommandA, CommandB));
		} 

	}
}

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


class CommandA
{
	[Inject]
	public var commandTracker:CommandTracker;
	
	public function execute():void
	{
		commandTracker.notify(CommandA);
	}
}

class CommandB
{
	[Inject]
	public var commandTracker:CommandTracker;
	
	public function execute():void
	{
		commandTracker.notify(CommandB);
	}
}