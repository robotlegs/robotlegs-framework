/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.robotlegs.base
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.flexunit.Assert;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.mvcs.support.ICommandTest;
	import org.robotlegs.mvcs.support.CustomEventCommand;
	import org.robotlegs.mvcs.support.CustomEvent;
	
	public class CommandMapWithEventClassTests implements ICommandTest
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
		public function hasCommandForSpecifiedEventClass():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			var hasCommand:Boolean = commandMap.hasEventCommand(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			Assert.assertTrue('Command Map should have Command', hasCommand);
		}
		
		[Test]
		public function shouldNotHaveCommandForUnmappedEventClass():void
		{
			var unmappedEventClass:Class = MouseEvent;
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			var hasCommand:Boolean = commandMap.hasEventCommand(CustomEvent.STARTED, CustomEventCommand, unmappedEventClass);
			Assert.assertFalse('Command Map should not have Command for wrong event class', hasCommand);
		}
		
		[Test]
		public function normalCommand():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
		}
		
		[Test]
		public function dispatchingUnmappedEventClassShouldNotExecuteCommand():void
		{
			var unmappedEventClass:Class = MouseEvent;
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			eventDispatcher.dispatchEvent(new unmappedEventClass(CustomEvent.STARTED));
			Assert.assertFalse('Command should not have reponded to unmapped event', commandExecuted);
		}
		
		[Test]
		public function normalCommandRepeated():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event again', commandExecuted);
		}
		
		[Test]
		public function oneshotCommandShouldBeRemovedAfterFirstExecution():void
		{
			var oneshot:Boolean = true;
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent, oneshot);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			var hasCommand:Boolean = commandMap.hasEventCommand(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			Assert.assertFalse('Command Map should NOT have oneshot Command after first execution', hasCommand);
		}
		
		[Test]
		public function oneshotCommandShouldNotExecuteASecondTime():void
		{
			var oneshot:Boolean = true;
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent, oneshot);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertFalse('Oneshot Command should NOT have reponded to event a second time', commandExecuted);
		}
		
		[Test]
		public function normalCommandRemoved():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			commandMap.unmapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			eventDispatcher.dispatchEvent(new CustomEvent(CustomEvent.STARTED));
			Assert.assertFalse('Command should NOT have reponded to event', commandExecuted);
		}
		
		[Test(expects="org.robotlegs.base.ContextError")]
		public function mappingNonCommandClassShouldFail():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, Object, CustomEvent);
		}
		
		[Test(expects="org.robotlegs.base.ContextError")]
		public function mappingSameThingTwiceShouldFail():void
		{
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
			commandMap.mapEvent(CustomEvent.STARTED, CustomEventCommand, CustomEvent);
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
