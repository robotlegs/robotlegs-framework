//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessorTest;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HookMapTest;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessorTest;
	import org.robotlegs.v2.extensions.guardsAndHooks.ViewHookMapTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class GuardsAndHooksTestSuite
	{

		public var guardsProcessorTest:GuardsProcessorTest;

		public var hookUtilityMapTest:HookMapTest;

		public var hooksProcessorTest:HooksProcessorTest;

		public var viewHookMap:ViewHookMapTest;
	}
}
