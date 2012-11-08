//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;

	public class EventCommandMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var dispatcher:EventDispatcher;

		private var eventCommandMap:IEventCommandMap;

		private var reportedExecutions:Array;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			const injector:Injector = new Injector();
			injector.map(Function, "reportingFunction").toValue(reportingFunction);
			reportedExecutions = [];
			dispatcher = new EventDispatcher();
			eventCommandMap = new EventCommandMap(injector, dispatcher, new CommandCenter());
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function map_creates_mapper():void
		{
			assertThat(eventCommandMap.map(SupportEvent.TYPE1, SupportEvent), instanceOf(ICommandMapper));
		}

		[Test]
		public function map_to_identical_Type_and_Event_returns_same_mapper():void
		{
			const mapper:Object = eventCommandMap.map(SupportEvent.TYPE1, SupportEvent);
			assertThat(eventCommandMap.map(SupportEvent.TYPE1, SupportEvent), equalTo(mapper));
		}

		[Test]
		public function map_to_identical_Type_but_different_Event_returns_different_mapper():void
		{
			const mapper:Object = eventCommandMap.map(SupportEvent.TYPE1, SupportEvent);
			assertThat(eventCommandMap.map(SupportEvent.TYPE1, Event), not(equalTo(mapper)));
		}

		[Test]
		public function map_to_different_Type_but_identical_Event_returns_different_mapper():void
		{
			const mapper:Object = eventCommandMap.map(SupportEvent.TYPE1, SupportEvent);
			assertThat(eventCommandMap.map(SupportEvent.TYPE2, SupportEvent), not(equalTo(mapper)));
		}

		[Test]
		public function unmap_returns_mapper():void
		{
			const mapper:Object = eventCommandMap.map(SupportEvent.TYPE1, SupportEvent);
			assertThat(eventCommandMap.unmap(SupportEvent.TYPE1, SupportEvent), equalTo(mapper));
		}

		[Test]
		public function robust_to_unmapping_non_existent_mappings():void
		{
			eventCommandMap.unmap(SupportEvent.TYPE1).fromCommand(NullCommand);
		}

		[Test]
		public function execution_sequence_is_guard_command_guard_command_for_multiple_mappings_to_same_event():void
		{
			// TODO: move into trigger tests
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandA).withGuards(GuardA);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(CommandB).withGuards(GuardB);
			dispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));
			const expectedOrder:Array = [GuardA, CommandA, GuardB, CommandB];
			assertThat(reportedExecutions, array(expectedOrder));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function reportingFunction(item:Object):void
		{
			reportedExecutions.push(item);
		}
	}
}

class GuardA
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		reportingFunc(GuardA);
		return true;
	}
}

class GuardB
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		reportingFunc(GuardB);
		return true;
	}
}

class GuardC
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		reportingFunc(GuardC);
		return true;
	}
}

class CommandA
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc(CommandA);
	}
}

class CommandB
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="reportingFunction")]
	public var reportingFunc:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function execute():void
	{
		reportingFunc(CommandB);
	}
}
