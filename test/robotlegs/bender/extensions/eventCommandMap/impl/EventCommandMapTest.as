//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.EventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.CommandMappingError;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
	import robotlegs.bender.framework.api.MappingConfigError;

	public class EventCommandMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var dispatcher:EventDispatcher;

		private var commandCenter:ICommandCenter;

		private var eventCommandMap:IEventCommandMap;
		
		private var errorImport:CommandMappingError;
		
		private var reportedExecutions:Array;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			reportedExecutions = [];
			injector = new Injector();
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			dispatcher = new EventDispatcher();
			commandCenter = new CommandCenter();
			eventCommandMap = new EventCommandMap(injector, dispatcher, commandCenter);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function mapEvent_creates_mapper():void
		{
			assertThat(eventCommandMap.map(SupportEvent.TYPE1, SupportEvent), notNullValue());
		}

		[Test]
		public function mapEvent_to_command_stores_mapping():void
		{
			const mapping:* = eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand);
			assertThat(eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand), equalTo(mapping));
		}

		[Test]
		public function unmapEvent_from_command_removes_mapping():void
		{
			const mapping:* = eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand);
			eventCommandMap.unmap(SupportEvent.TYPE1).fromCommand(NullCommand);
			assertThat(eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand), not(equalTo(mapping)));
		}
		
		// Duplicating these tests from commandMapping at this level to keep it honest!
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function different_guard_mapping_throws_mapping_error():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withGuards(GuardA, GuardB);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withGuards(GuardA, GuardC);
		}
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function different_hook_mapping_throws_mapping_error():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withHooks(HookA, HookC);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withHooks(HookB);
		}
		
		// Testing of the ommission style of error is done in the Executor... as expecting async errors is gnarly
	
		[Test]
		public function robust_to_unmapping_non_existent_mappings():void
		{
			eventCommandMap.unmap(SupportEvent.TYPE1).fromCommand(NullCommand);
		}
		
		[Test]
		public function execution_sequence_is_guard_command_guard_command_for_multiple_mappings_to_same_event():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandA).withGuards(GuardA);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandB).withGuards(GuardB);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			const expectedOrder:Array = [GuardA, CommandA, GuardB, CommandB];
			assertThat(reportedExecutions, array(expectedOrder));
		}
		
		protected function reportingFunction(item:Object):void
		{
			reportedExecutions.push(item);
		}
	}
}

class GuardA
{
	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;
	
	public function approve():Boolean
	{
		reportingFunc(GuardA);
		return true;
	}
}

class GuardB
{
	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;
	
	public function approve():Boolean
	{
		reportingFunc(GuardB);
		return true;
	}
}

class GuardC
{
	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;
	
	public function approve():Boolean
	{
		reportingFunc(GuardC);
		return true;
	}
}

class HookA
{
	public function hook():void
	{
	}
}

class HookB
{
	public function hook():void
	{
	}
}

class HookC
{
	public function hook():void
	{
	}
}

class CommandA
{
	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;
	
	public function execute():void
	{
		reportingFunc(CommandA);
	}
	
}

class CommandB
{
	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;
	
	public function execute():void
	{
		reportingFunc(CommandB);
	}
	
}