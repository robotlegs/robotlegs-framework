//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.IEventDispatcher;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMapping;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;

	public class EventCommandTriggerTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var dispatcher:IEventDispatcher;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var trigger:EventCommandTrigger;

		private var injector:Injector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			trigger = new EventCommandTrigger(injector, dispatcher, null, null);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(expects="Error")]
		public function mapping_nonCommandClass_throws_error():void
		{
			// NOTE: we do this here, not in the CommandCenter itself
			// Some triggers don't require an execute() method
			trigger.addMapping(new CommandMapping(Object));
		}

		[Test]
		public function adding_the_first_mapping_adds_a_listener():void
		{
			trigger.addMapping(new CommandMapping(NullCommand));
			assertThat(dispatcher, received().method('addEventListener').once());
		}

		[Test]
		public function adding_another_mapping_does_not_add_listener_again():void
		{
			trigger.addMapping(new CommandMapping(NullCommand));
			trigger.addMapping(new CommandMapping(NullCommand));
			assertThat(dispatcher, received().method('addEventListener').once());
		}

		[Test]
		public function removing_the_last_mapping_removes_the_listener():void
		{
			const mapping:CommandMapping = new CommandMapping(NullCommand);
			trigger.addMapping(mapping);
			trigger.removeMapping(mapping);
			assertThat(dispatcher, received().method('removeEventListener').once());
		}

		[Test]
		public function removing_a_mapping_does_NOT_remove_the_listener_when_other_mappings_still_exist():void
		{
			const mapping:CommandMapping = new CommandMapping(NullCommand);
			trigger.addMapping(mapping);
			trigger.addMapping(new CommandMapping(NullCommand));
			trigger.removeMapping(mapping);
			assertThat(dispatcher, received().method('removeEventListener').never());
		}
	}
}
