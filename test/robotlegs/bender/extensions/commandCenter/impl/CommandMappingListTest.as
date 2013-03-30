//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import org.hamcrest.text.containsString;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand2;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand3;
	import robotlegs.bender.framework.api.ILogger;

	public class CommandMappingListTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var logger:ILogger;

		[Mock]
		public var trigger:ICommandTrigger;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:CommandMappingList;

		private var mapping1:ICommandMapping;

		private var mapping2:ICommandMapping;

		private var mapping3:ICommandMapping;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			subject = new CommandMappingList(logger);
			subject.trigger = trigger;
			mapping1 = new CommandMapping(NullCommand);
			mapping2 = new CommandMapping(NullCommand2);
			mapping3 = new CommandMapping(NullCommand3);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function trigger_is_activated_when_first_mapping_is_added():void
		{
			mock(trigger).method("activate").once();
			subject.addMapping(mapping1);
		}

		[Test]
		public function trigger_is_not_activated_when_second_mapping_is_added():void
		{
			mock(trigger).method("activate").once();
			subject.addMapping(mapping1);
			subject.addMapping(mapping2);
		}

		[Test]
		public function trigger_is_not_activated_when_mapping_overwritten():void
		{
			mock(trigger).method("activate").once();
			subject.addMapping(new CommandMapping(NullCommand));
			subject.addMapping(new CommandMapping(NullCommand));
		}

		[Test]
		public function trigger_is_not_activated_for_second_identical_mapping():void
		{
			mock(trigger).method("activate").once();
			subject.addMapping(mapping1);
			subject.addMapping(mapping1);
		}

		[Test]
		public function trigger_is_deactivated_when_last_mapping_is_removed():void
		{
			mock(trigger).method("deactivate").once();
			subject.addMapping(mapping1);
			subject.addMapping(mapping2);
			subject.removeMappingFor(mapping1.commandClass);
			subject.removeMappingFor(mapping2.commandClass);
		}

		[Test]
		public function trigger_is_deactivated_when_all_mappings_are_removed():void
		{
			mock(trigger).method("deactivate").once();
			subject.addMapping(mapping1);
			subject.addMapping(mapping2);
			subject.addMapping(mapping3);
			subject.removeAllMappings();
		}

		[Test]
		public function trigger_is_not_deactivated_when_second_last_mapping_is_removed():void
		{
			mock(trigger).method("deactivate").never();
			subject.addMapping(mapping1);
			subject.addMapping(mapping2);
			subject.removeMappingFor(mapping1.commandClass);
		}

		[Test]
		public function warning_logged_when_mapping_overwritten():void
		{
			mock(logger).method("warn")
				.args(containsString("already mapped"), notNullValue()).once();
			subject.addMapping(new CommandMapping(NullCommand));
			subject.addMapping(new CommandMapping(NullCommand));
		}

		[Test]
		public function list_is_empty():void
		{
			assertThat(subject.getList().length, equalTo(0));
		}

		[Test]
		public function list_not_empty_after_mapping_added():void
		{
			subject.addMapping(mapping1);
			assertThat(subject.getList().length, equalTo(1));
		}

		[Test]
		public function list_has_mapping():void
		{
			subject.addMapping(mapping1);
			assertThat(subject.getList().indexOf(mapping1), equalTo(0));
		}

		[Test]
		public function list_is_empty_after_mappings_are_removed():void
		{
			subject.addMapping(mapping1);
			subject.addMapping(mapping2);
			subject.removeMapping(mapping1);
			subject.removeMapping(mapping2);
			assertThat(subject.getList().length, equalTo(0));
		}

		[Test]
		public function list_is_empty_after_removeAll():void
		{
			subject.addMapping(mapping1);
			subject.addMapping(mapping2);
			subject.addMapping(mapping3);
			subject.removeAllMappings();
			assertThat(subject.getList().length, equalTo(0));
		}

		[Test]
		public function getList_returns_unique_list():void
		{
			assertThat(subject.getList(), not(equalTo(subject.getList())));
		}

		[Test]
		public function getList_returns_similar_list():void
		{
			subject.addMapping(mapping1);
			assertThat(subject.getList()[0], equalTo(subject.getList()[0]));
		}

	}
}
