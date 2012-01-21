//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap
{
	import robotlegs.bender.extensions.messageCommandMap.impl.MessageCommandMapTest;
	import robotlegs.bender.extensions.messageCommandMap.impl.MessageCommandTriggerTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class MessageCommandMapExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var messageCommandMapExtension:MessageCommandMapExtensionTest;

		public var messageCommandMap:MessageCommandMapTest;

		public var messageCommandTrigger:MessageCommandTriggerTest;
	}
}
