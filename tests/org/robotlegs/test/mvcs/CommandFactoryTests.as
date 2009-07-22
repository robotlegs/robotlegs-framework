package org.robotlegs.test.mvcs
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import net.expantra.smartypants.extra.NoSmartyPantsLogging;
	
	import org.flexunit.Assert;
	import org.robotlegs.adapters.SmartyPantsInjector;
	import org.robotlegs.adapters.SmartyPantsReflector;
	import org.robotlegs.core.ICommandFactory;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.mvcs.CommandFactory;
	import org.robotlegs.test.mvcs.support.TestCommand;
	
	public class CommandFactoryTests
	{
		public static const nologger:* = new NoSmartyPantsLogging(null);
		public static const TEST_EVENT:String = 'testEvent';
		
		private var eventDispatcher:IEventDispatcher;
		private var commandExecuted:Boolean;
		private var commandFactory:ICommandFactory;
		private var injector:IInjector;
		private var reflector:IReflector;
		
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
			injector = new SmartyPantsInjector();
			reflector = new SmartyPantsReflector();
			commandFactory = new CommandFactory(eventDispatcher, injector, reflector);
			injector.bindValue(CommandFactoryTests, this);
		}
		
		[After]
		public function runAfterEachTest():void
		{
			injector.unbind(CommandFactoryTests);
			resetCommandExecuted();
		}
		
		[Test]
		public function noCommand():void
		{
			eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
			Assert.assertFalse('Command should not have reponded to event', commandExecuted);
		}
		
		[Test]
		public function hasCommand():void
		{
			commandFactory.mapCommand(TEST_EVENT, TestCommand);
			var hasCommand:Boolean = commandFactory.hasCommand(TEST_EVENT, TestCommand);
			Assert.assertTrue('Command Factory should have Command', hasCommand);
		}
		
		[Test]
		public function normalCommand():void
		{
			commandFactory.mapCommand(TEST_EVENT, TestCommand);
			eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
		}
		
		[Test]
		public function normalCommandRepeated():void
		{
			commandFactory.mapCommand(TEST_EVENT, TestCommand);
			eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
			Assert.assertTrue('Command should have reponded to event again', commandExecuted);
		}
		
		[Test]
		public function oneshotCommand():void
		{
			commandFactory.mapCommand(TEST_EVENT, TestCommand, true);
			eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
			Assert.assertFalse('Command should NOT have reponded to event', commandExecuted);
		}
		
		[Test]
		public function normalCommandRemoved():void
		{
			commandFactory.mapCommand(TEST_EVENT, TestCommand);
			eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
			Assert.assertTrue('Command should have reponded to event', commandExecuted);
			resetCommandExecuted();
			commandFactory.unmapCommand(TEST_EVENT, TestCommand);
			eventDispatcher.dispatchEvent(new Event(TEST_EVENT));
			Assert.assertFalse('Command should NOT have reponded to event', commandExecuted);
		}
		
		[Ignore]
		[Test(expects="net.robotlegs.mvcs.ContextError")]
		public function mapCommandImplError():void
		{
			commandFactory.mapCommand(TEST_EVENT, Object);
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