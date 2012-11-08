//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.extensions.messageCommandMap.api.IMessageCommandMap;
	import robotlegs.bender.framework.impl.MessageDispatcher;

	public class MessageCommandMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var dispatcher:MessageDispatcher;

		private var messageCommandMap:IMessageCommandMap;

		private var message:Object;

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
			dispatcher = new MessageDispatcher();
			messageCommandMap = new MessageCommandMap(injector, dispatcher, new CommandCenter());
			message = {};
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function map_creates_mapper():void
		{
			assertThat(messageCommandMap.map(message), instanceOf(ICommandMapper));
		}

		[Test]
		public function map_to_identical_message_returns_same_mapper():void
		{
			const mapper:Object = messageCommandMap.map(message);
			assertThat(messageCommandMap.map(message), equalTo(mapper));
		}

		[Test]
		public function unmap_returns_mapper():void
		{
			const mapper:Object = messageCommandMap.map(message);
			assertThat(messageCommandMap.unmap(message), equalTo(mapper));
		}

		[Test]
		public function execution_sequence_is_guard_command_guard_command_for_multiple_mappings_to_same_message():void
		{
			// TODO: move into trigger tests
			messageCommandMap.map(message).toCommand(CommandA).withGuards(GuardA);
			messageCommandMap.map(message).toCommand(CommandB).withGuards(GuardB);
			dispatcher.dispatchMessage(message);
			const expectedOrder:Array = [GuardA, CommandA, GuardB, CommandB];
			assertThat(reportedExecutions, array(expectedOrder));
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function reportingFunction(item:Object):void
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
