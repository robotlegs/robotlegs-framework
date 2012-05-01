//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.lifecycle
{
	import robotlegs.bender.framework.lifecycle.impl.LifecycleTest;
	import robotlegs.bender.framework.lifecycle.impl.LifecycleTransitionTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class LifecycleTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var lifecycle:LifecycleTest;

		public var lifecycleTransition:LifecycleTransitionTest;
	}
}
