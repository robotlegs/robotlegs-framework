//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import robotlegs.bender.extensions.mediatorMap.impl.DefaultMediatorManagerTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorFactoryTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorViewHandlerTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorSugarTest;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMapTestPreloaded;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class MediatorMapExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var mediatorMapExtension:MediatorMapExtensionTest;

		public var mediatorHandler:MediatorViewHandlerTest;

		public var mediatorFactory:MediatorFactoryTest;

		public var defaultMediatorManager:DefaultMediatorManagerTest;
		
		// added by stray recovered from pre-reloaded tests
		
		public var mediatorMapTestsOriginal:MediatorMapTestPreloaded;
		
		public var mediatorSugarTest:MediatorSugarTest;
	}
}