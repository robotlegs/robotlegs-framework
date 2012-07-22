//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
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

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
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
			messageCommandMap.map(message).toCommand(NullCommand);
			assertThat(messageCommandMap.getMapping(message).forCommand(NullCommand), notNullValue());
		}

		[Test]
		public function unmapMessage_from_command_removes_mapping():void
		{
			messageCommandMap.map(message).toCommand(NullCommand);
			messageCommandMap.unmap(message).fromCommand(NullCommand);
			assertThat(messageCommandMap.getMapping(message).forCommand(NullCommand), nullValue());
		}
		
		[Test]
		public function robust_to_unmapping_non_existent_mappings():void
		{
			messageCommandMap.unmap(message).fromCommand(NullCommand);
		}
	}
}
