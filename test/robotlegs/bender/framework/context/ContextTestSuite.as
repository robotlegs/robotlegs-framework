//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.context
{
	import robotlegs.bender.framework.context.impl.ConfigManagerTest;
	import robotlegs.bender.framework.context.impl.ContextTest;
	import robotlegs.bender.framework.context.impl.ExtensionInstallerTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ContextTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var context:ContextTest;

		public var configManager:ConfigManagerTest;

		public var extensionInstaller:ExtensionInstallerTest;
	}
}
