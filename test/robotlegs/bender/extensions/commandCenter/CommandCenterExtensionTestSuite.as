//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter
{
	import robotlegs.bender.extensions.directCommandMap.impl.DirectCommandMapTest;
	import robotlegs.bender.extensions.commandCenter.impl.CommandExecutorTest;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMapperTest;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingListTest;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingTest;
	import robotlegs.bender.extensions.commandCenter.impl.CommandPayloadTest;
	import robotlegs.bender.extensions.commandCenter.impl.CommandTriggerMapTest;
	import robotlegs.bender.extensions.directCommandMap.DirectCommandMapExtensionTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class CommandCenterExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var commandTriggerMap:CommandTriggerMapTest;

		public var commandMapper:CommandMapperTest;

		public var commandMapping:CommandMappingTest;

		public var commandExecutor:CommandExecutorTest;

		public var commandMappingList:CommandMappingListTest;

		public var commandPayload : CommandPayloadTest;

		public var commandCenter : DirectCommandMapTest;

	}
}
