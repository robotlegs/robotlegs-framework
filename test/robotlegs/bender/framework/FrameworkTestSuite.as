//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework
{
	import robotlegs.bender.framework.config.manager.impl.ConfigManagerTest;
	import robotlegs.bender.framework.context.impl.ContextTest;
	import robotlegs.bender.framework.guard.impl.GuardGroupTest;
	import robotlegs.bender.framework.hook.impl.HookGroupTest;
	import robotlegs.bender.framework.object.managed.impl.ManagedObjectTest;
	import robotlegs.bender.framework.object.manager.impl.ObjectManagerTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class FrameworkTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var configManager:ConfigManagerTest;

		public var objectManager:ObjectManagerTest;

		public var managedObject:ManagedObjectTest;

		public var guardGroup:GuardGroupTest;

		public var hookGroup:HookGroupTest;

		public var context:ContextTest;
	}
}
