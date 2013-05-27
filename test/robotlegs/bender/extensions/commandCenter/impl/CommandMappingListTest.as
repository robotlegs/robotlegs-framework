//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
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

		private var processors:Array;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			processors = [];
			subject = new CommandMappingList(trigger, processors, logger);
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
		public function trigger_is_not_deactivated_when_list_is_already_empty():void
		{
			mock(trigger).method("deactivate").never();
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
			subject.addMapping(mapping2);
			subject.addMapping(mapping3);
			const list1:Array = mappingsToArray(subject.getList());
			const list2:Array = mappingsToArray(subject.getList());
			assertThat(list1, array(list2));
		}

		[Test]
		public function sortFunction_is_used():void
		{
			subject.withSortFunction(function(a:PriorityMapping, b:PriorityMapping):int {
				if (a.priority == b.priority)
					return 0;
				return a.priority > b.priority ? 1 : -1;
			});
			const mapping1:PriorityMapping = new PriorityMapping(NullCommand, 1);
			const mapping2:PriorityMapping = new PriorityMapping(NullCommand2, 2);
			const mapping3:PriorityMapping = new PriorityMapping(NullCommand3, 3);
			subject.addMapping(mapping3);
			subject.addMapping(mapping1);
			subject.addMapping(mapping2);
			assertThat(mappingsToArray(subject.getList()), array(mapping1, mapping2, mapping3));
		}

		[Test]
		public function sortFunction_is_called_after_mappings_are_added():void
		{
			var called:Boolean = false;
			subject.withSortFunction(function(a:PriorityMapping, b:PriorityMapping):int {
				called = true;
				return 0;
			});
			addPriorityMappings();
			subject.getList();
			assertThat(called, isTrue());
		}

		[Test]
		public function sortFunction_is_only_called_once_after_mappings_are_added():void
		{
			var called:Boolean = false;
			subject.withSortFunction(function(a:PriorityMapping, b:PriorityMapping):int {
				called = true;
				return 0;
			});
			addPriorityMappings();
			subject.getList();
			called = false;
			subject.getList();
			assertThat(called, isFalse());
		}

		[Test]
		public function sortFunction_is_not_called_after_a_mapping_is_removed():void
		{
			var called:Boolean = false;
			subject.withSortFunction(function(a:PriorityMapping, b:PriorityMapping):int {
				called = true;
				return 0;
			});
			addPriorityMappings();
			subject.getList();
			called = false;
			subject.removeMappingFor(NullCommand);
			subject.getList();
			assertThat(called, isFalse());
		}

		[Test]
		public function mapping_processor_is_called():void
		{
			var callCount:int = 0;
			processors.push(function(mapping:CommandMapping):void {
				callCount++;
			});
			subject.addMapping(mapping1);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function mapping_processor_is_given_mappings():void
		{
			const mappings:Array = [];
			processors.push(function(mapping:CommandMapping):void {
				mappings.push(mapping);
			});
			subject.addMapping(mapping1);
			subject.addMapping(mapping2);
			subject.addMapping(mapping3);
			assertThat(mappings, array(mapping1, mapping2, mapping3));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function mappingsToArray(mappings:Vector.<ICommandMapping>):Array
		{
			const a:Array = [];
			for each (var mapping:ICommandMapping in mappings)
				a.push(mapping);
			return a;
		}

		private function addPriorityMappings():void
		{
			subject.addMapping(new PriorityMapping(NullCommand, 1));
			subject.addMapping(new PriorityMapping(NullCommand2, 2));
			subject.addMapping(new PriorityMapping(NullCommand3, 3));
		}
	}
}

import robotlegs.bender.extensions.commandCenter.impl.CommandMapping;

class PriorityMapping extends CommandMapping
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var priority:int;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	function PriorityMapping(command:Class, priority:int)
	{
		super(command);
		this.priority = priority;
	}
}
