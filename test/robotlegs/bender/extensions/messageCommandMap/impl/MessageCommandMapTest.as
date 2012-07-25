//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.impl.MessageDispatcher;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.messageCommandMap.api.IMessageCommandMap;

	public class MessageCommandMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var dispatcher:MessageDispatcher;

		private var commandCenter:ICommandCenter;

		private var messageCommandMap:IMessageCommandMap;

		private var message:Object;
		
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
			dispatcher = new MessageDispatcher();
			commandCenter = new CommandCenter();
			messageCommandMap = new MessageCommandMap(injector, dispatcher, commandCenter);
			message = {};
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function mapMessage_creates_mapper():void
		{
			assertThat(messageCommandMap.map(message), notNullValue());
		}

		[Test]
		public function mapMessage_to_command_stores_mapping():void
		{
			const mapping:* = messageCommandMap.map(message).toCommand(NullCommand);
			assertThat(messageCommandMap.map(message).toCommand(NullCommand), equalTo(mapping));
		}

		[Test]
		public function unmapMessage_from_command_removes_mapping():void
		{
			const mapping:* = messageCommandMap.map(message).toCommand(NullCommand);
			messageCommandMap.unmap(message).fromCommand(NullCommand);
			assertThat(messageCommandMap.map(message).toCommand(NullCommand), not(equalTo(mapping)));
		}
		
		[Test]
		public function robust_to_unmapping_non_existent_mappings():void
		{
			messageCommandMap.unmap(message).fromCommand(NullCommand);
		}
		
		[Test]
		public function execution_sequence_is_guard_command_guard_command_for_multiple_mappings_to_same_message():void
		{
			messageCommandMap.map(message).toCommand(CommandA).withGuards(GuardA);
			messageCommandMap.map(message).toCommand(CommandB).withGuards(GuardB);
			dispatcher.dispatchMessage(message);
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