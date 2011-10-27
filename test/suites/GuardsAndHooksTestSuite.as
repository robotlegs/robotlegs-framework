//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.extensions.hooks.HookBaseTest;
	import org.robotlegs.v2.extensions.hooks.HookUtilityMapTest;
	import org.robotlegs.v2.extensions.hooks.HooksProcessorTest;
	import org.robotlegs.v2.extensions.guards.GuardsProcessorTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class GuardsAndHooksTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var hookBaseTest:HookBaseTest;
		
		public var hookUtilityMapTest:HookUtilityMapTest;
		
		public var hooksProcessorTest:HooksProcessorTest;
		
		public var guardsProcessorTest:GuardsProcessorTest;
	}
}