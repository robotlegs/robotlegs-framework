//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.directCommandMap
{
	import robotlegs.bender.extensions.directCommandMap.impl.DirectCommandMapperTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class DirectCommandMapExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var directCommandMapExtension:DirectCommandMapExtensionTest;

		public var directCommandMapper : DirectCommandMapperTest;
	}
}
