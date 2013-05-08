//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity
{
	import robotlegs.bender.extensions.modularity.impl.ModuleConnectionConfiguratorTest;
	import robotlegs.bender.extensions.modularity.impl.ModuleConnectorTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ModularityExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var modularityExtension:ModularityExtensionTest;

		public var moduleConnector:ModuleConnectorTest;

		public var moduleConnectionConfigurator:ModuleConnectionConfiguratorTest;
	}
}
