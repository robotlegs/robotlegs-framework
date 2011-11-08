//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessorTest;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessorTest;
	import org.robotlegs.v2.extensions.viewHookMap.HookMapTest;
	import org.robotlegs.v2.extensions.viewHookMap.ViewHookMapTest;

	[Deprecated(message="any class, method or property with the word AND in it is banned :)")]
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
