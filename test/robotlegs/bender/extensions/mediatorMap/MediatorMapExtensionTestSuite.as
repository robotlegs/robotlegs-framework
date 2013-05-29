//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorManagerTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorFactoryTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMapMemoryLeakTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMapTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMapTestPreloaded;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMapperTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorSugarTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorViewHandlerTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class MediatorMapExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var mediatorMapExtension:MediatorMapExtensionTest;

		public var mediatorMap:MediatorMapTest;

		public var mediatorMapper:MediatorMapperTest;

		public var mediatorHandler:MediatorViewHandlerTest;

		public var mediatorFactory:MediatorFactoryTest;

		public var mediatorManager:MediatorManagerTest;

		// added by stray recovered from pre-reloaded tests

		public var mediatorMapTestsOriginal:MediatorMapTestPreloaded;

		public var mediatorSugarTest:MediatorSugarTest;

		// Does not work on our CI server
		// public var mediatorMapMemoryLeak:MediatorMapMemoryLeakTest;
	}
}
