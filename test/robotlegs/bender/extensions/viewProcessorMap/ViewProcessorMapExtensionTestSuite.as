//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap
{
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewInjectionProcessorTest;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewProcessorMapTest;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewProcessorFactoryTest;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewProcessorMapperTest;
	import robotlegs.bender.extensions.viewProcessorMap.utils.FastPropertyInjectorTest;
	import robotlegs.bender.extensions.viewProcessorMap.utils.PropertyValueInjectorTest;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewProcessorMediatorsTest;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewProcessorMappingTest;
	
	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class ViewProcessorMapExtensionTestSuite
	{
		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var viewProcessorMap:ViewProcessorMapTest;
		
		public var viewProcessorFactory:ViewProcessorFactoryTest;

		public var viewInjector:ViewInjectionProcessorTest;
		
		public var fastPropertyInjector:FastPropertyInjectorTest;
		
		public var propertyValueInjector:PropertyValueInjectorTest;
		
		public var viewProcessMapExtension:ViewProcessorMapExtensionTest;
		
		public var viewProcessorMediators:ViewProcessorMediatorsTest;
		
		public var viewProcessorMapping:ViewProcessorMappingTest;

		public var viewProcessorMapper:ViewProcessorMapperTest;

	}
}