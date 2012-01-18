//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.object
{
	import robotlegs.bender.framework.object.managed.impl.ManagedObjectTest;
	import robotlegs.bender.framework.object.manager.impl.ObjectManagerTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ObjectTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var managedObject:ManagedObjectTest;

		public var objectManager:ObjectManagerTest;
	}
}
