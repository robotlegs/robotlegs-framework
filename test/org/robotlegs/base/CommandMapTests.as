/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.support.ManualCommand;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.mvcs.support.AbstractEventCommand;
	import org.robotlegs.mvcs.support.AbstractEventNamedCommand;
	import org.robotlegs.mvcs.support.CustomEvent;
	import org.robotlegs.mvcs.support.EventCommand;
	import org.robotlegs.mvcs.support.ICommandTest;
	
	public class CommandMapTests implements ICommandTest
	{
		protected var eventDispatcher:IEventDispatcher;
		protected var commandExecuted:Boolean;
		protected var commandMap:ICommandMap;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		
		[BeforeClass]
		public static function runBeforeEntireSuite():void
		{
		}
		
		[AfterClass]
		public static function runAfterEntireSuite():void
		{
		}
		
		[Before]
		public function runBeforeEachTest():void
		{
			eventDispatcher = new EventDispatcher();
			injector = new SwiftSuspendersInjector();
			reflector = new SwiftSuspendersReflector();
			commandMap = new CommandMap(eventDispatcher, injector, reflector);
			injector.mapValue(ICommandTest, this);
		}
		
		[After]
		public function runAfterEachTest():void
		{
			injector.unmap(ICommandTest);
			resetCommandExecuted();
		}
		
		[Test]
		public function noCommand():void
		{
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertFalse('Command should not have reponded to event', commandExecuted);
		}
		
		[Test]
		public function hasCommand():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
			var hasCommand:Boolean = commandMap.hasEventCommand(CustomEvent.STARTED, EventCommand);
			Assert.assertTrue('Command Map should have Command', hasCommand);
		}
		
		[Test]
		public function normalCommand():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
		}
		
		[Test]
		public function normalCommandRepeated():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event again', commandExecuted);
		}
		
		[Test]
		public function oneshotCommand():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand, null, true);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertFalse('Command should NOT have reponded to event', commandExecuted);
		}
		
		[Test]
		public function normalCommandRemoved():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			commandMap.unmapEvent(CustomEvent.STARTED, EventCommand);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertFalse('Command should NOT have reponded to event', commandExecuted);
		}
		
		[Test]
		public function unmapEvents():void
		{
			commandMap.mapEvent(CustomEvent.EVENT0, EventCommand);
			commandMap.mapEvent(CustomEvent.EVENT1, EventCommand);
			commandMap.mapEvent(CustomEvent.EVENT2, EventCommand);
			commandMap.mapEvent(CustomEvent.EVENT3, EventCommand);
			commandMap.unmapEvents();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT0));
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT1));
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT2));
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.EVENT3));
			Assert.assertFalse('Command should NOT have reponded to event', commandExecuted);
		}
		
		[Test]
		public function manuallyExecute():void
		{
			commandMap.execute(ManualCommand, {});
			Assert.assertTrue('Command should have executed with custom payload', commandExecuted);
		}
		
		[Test(expects="org.robotlegs.base.ContextError")]
		public function mappingNonCommandClassShouldFail():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, Object);
		}
		
		[Test(expects="org.robotlegs.base.ContextError")]
		public function mappingSameThingTwiceShouldFail():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
			commandMap.mapEvent(CustomEvent.STARTED, EventCommand);
		}
		
		[Test]
		public function abstractEventInjectingCommand():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, AbstractEventCommand);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have been injected with CustomEvent and Event', commandExecuted);
		}

		[Test]
		public function abstractEventInjectingNamedCommand():void
		{
			var event:CustomEvent = new CustomEvent(CustomEvent.STARTED);

			commandMap.mapEvent(CustomEvent.STARTED, AbstractEventNamedCommand);
			commandMap.execute(AbstractEventNamedCommand, event, null, "custom");
			Assert.assertTrue('Command should have been injected with named CustomEvent and Event', commandExecuted);
		}

		public function markCommandExecuted():void
		{
			commandExecuted = true;
		}
		
		public function resetCommandExecuted():void
		{
			commandExecuted = false;
		}
	}
}
