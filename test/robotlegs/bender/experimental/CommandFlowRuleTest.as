//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.experimental
{
	import org.flexunit.asserts.*;
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import flash.events.Event;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.swiftsuspenders.Injector;

	public class CommandFlowRuleTest
	{
		private var instance:CommandFlowRule;

		private var injector:Injector;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			instance = new CommandFlowRule(injector);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is CommandFlowRule", instance is CommandFlowRule);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test]
		public function execute_adds_to_commandClasses_list():void
		{
			instance.execute(SomeCommand);
			assertThat(instance.commandClasses, array(SomeCommand));
		}

		[Test]
		public function executeAll_adds_all_to_commandClasses_list():void
		{
			instance.executeAll(SomeCommand, AnotherCommand);
			assertThat(instance.commandClasses, array(SomeCommand, AnotherCommand));
		}

		[Test]
		public function requireOnlyRule_returns_true_if_passed_required_event():void
		{
			instance = new CommandFlowRequireOnlyRule(Event.COMPLETE, injector);
			assertTrue(instance.applyEvent(new Event(Event.COMPLETE)));
		}

		[Test]
		public function requireOnlyRule_returns_false_if_passed_unrequired_event():void
		{
			instance = new CommandFlowRequireOnlyRule(Event.COMPLETE, injector);
			assertFalse(instance.applyEvent(new Event(Event.CHANGE)));
		}

		[Test]
		public function requireOnlyRule_returns_list_of_events_received_correctly():void
		{
			instance = new CommandFlowRequireOnlyRule(Event.COMPLETE, injector);
			const evt:Event = new Event(Event.COMPLETE);
			instance.applyEvent(evt);
			assertThat(instance.receivedEvents, array(evt));
		}

		[Test]
		public function requireAnyRule_returns_true_if_passed_one_required_event():void
		{
			instance = new CommandFlowRequireAnyRule(new <String>[Event.COMPLETE, Event.CHANGE], injector);
			assertTrue(instance.applyEvent(new Event(Event.COMPLETE)));
		}

		[Test]
		public function requireAnyRule_returns_true_if_passed_different_required_event():void
		{
			instance = new CommandFlowRequireAnyRule(new <String>[Event.COMPLETE, Event.CHANGE], injector);
			assertTrue(instance.applyEvent(new Event(Event.CHANGE)));
		}

		[Test]
		public function requireAnyRule_returns_false_if_passed_unrequired_event():void
		{
			instance = new CommandFlowRequireAnyRule(new <String>[Event.COMPLETE, Event.CHANGE], injector);
			assertFalse(instance.applyEvent(new Event(Event.CANCEL)));
		}

		[Test]
		public function requireAnyRule_returns_list_of_events_received_correctly():void
		{
			instance = new CommandFlowRequireAnyRule(new <String>[Event.COMPLETE, Event.CHANGE], injector);
			const evt:Event = new Event(Event.COMPLETE);
			instance.applyEvent(evt);
			assertThat(instance.receivedEvents, array(evt));
		}

		[Test]
		public function requireAllRule_returns_true_only_once_passed_final_required_event():void
		{
			instance = new CommandFlowRequireAllRule(new <String>[Event.COMPLETE, Event.CHANGE], injector);
			assertFalse(instance.applyEvent(new Event(Event.CHANGE)));
			assertTrue(instance.applyEvent(new Event(Event.COMPLETE)));
		}

		[Test]
		public function requireAllRule_returns_true_only_once_passed_final_required_event_diff_circumstances():void
		{
			instance = new CommandFlowRequireAllRule(new <String>[Event.COMPLETE, Event.CHANGE], injector);
			assertFalse(instance.applyEvent(new Event(Event.COMPLETE)));
			assertFalse(instance.applyEvent(new Event(Event.COMPLETE)));
			assertFalse(instance.applyEvent(new Event(Event.CANCEL)));
			assertTrue(instance.applyEvent(new Event(Event.CHANGE)));
		}

		[Test]
		public function requireAllRule_returns_last_relevant_given_events():void
		{
			instance = new CommandFlowRequireAllRule(new <String>[Event.COMPLETE, Event.CHANGE], injector);

			var evt1:Event = new Event(Event.COMPLETE);
			var evt2:Event = new Event(Event.COMPLETE);
			var evt3:Event = new Event(Event.CANCEL);
			var evt4:Event = new Event(Event.CHANGE);

			instance.applyEvent(evt1);
			instance.applyEvent(evt2);
			instance.applyEvent(evt3);
			instance.applyEvent(evt4);

			assertEqualsVectorsIgnoringOrder(instance.receivedEvents, new <Event>[evt2, evt4]);
		}

	}
}

class SomeCommand
{

}

class AnotherCommand
{

}