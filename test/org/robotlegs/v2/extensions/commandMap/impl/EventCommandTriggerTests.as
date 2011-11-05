//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.support.CallbackCommand;
	import org.robotlegs.v2.extensions.commandMap.support.SupportEvent;
	import org.swiftsuspenders.Injector;

	public class EventCommandTriggerTests
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

		[Test(expects="Error")]
		public function mapping_nonCommandClass_to_event_should_throw_error():void
		{
			// NOTE: we do this here, not in the Command Map itself
			// It is up to the trigger to execute commands
			// A particular trigger might not require an execute() method
			commandMap.map(Object).toEvent(SupportEvent.TYPE1);
		}

		[Test]
		public function command_executes_when_correct_event_dispatched():void
		{
			var executeCount:uint;
			injector.map(Function, 'callback').toValue(function():void
			{
				executeCount++;
			});
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(1));
		}

		[Test]
		public function command_executes_repeatedly_when_correct_event_dispatched_repeatedly():void
		{
			var executeCount:uint;
			injector.map(Function, 'callback').toValue(function():void
			{
				executeCount++;
			});
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(3));
		}

		[Test]
		public function command_does_not_execute_when_incorrect_eventType_dispatched():void
		{
			var executeCount:uint;
			injector.map(Function, 'callback').toValue(function():void
			{
				executeCount++;
			});
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE2));
			assertThat(executeCount, equalTo(0));
		}

		[Test]
		public function command_does_not_execute_when_incorrect_eventClass_dispatched():void
		{
			var executeCount:uint;
			injector.map(Function, 'callback').toValue(function():void
			{
				executeCount++;
			});
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1, SupportEvent);
			dispatcher.dispatchEvent(new Event(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(0));
		}

		[Test]
		public function command_does_not_execute_after_event_unmapped():void
		{
			var executeCount:uint;
			injector.map(Function, 'callback').toValue(function():void
			{
				executeCount++;
			});
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1, SupportEvent);
			commandMap.unmap(CallbackCommand).fromEvent(SupportEvent.TYPE1, SupportEvent);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(0));
		}

		[Test]
		public function command_does_not_execute_after_oneshot():void
		{
			var executeCount:uint;
			injector.map(Function, 'callback').toValue(function():void
			{
				executeCount++;
			});
			commandMap.map(CallbackCommand).toEvent(SupportEvent.TYPE1, SupportEvent, true);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			assertThat(executeCount, equalTo(1));
		}
	}
}
