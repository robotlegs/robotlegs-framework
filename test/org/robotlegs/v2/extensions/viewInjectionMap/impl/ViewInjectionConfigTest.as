//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewInjectionMap.impl 
{
	import org.flexunit.asserts.*;

	public class ViewInjectionConfigTest 
	{
		private var instance:ViewInjectionConfig;

		[Before]
		public function setUp():void
		{
			instance = new ViewInjectionConfig();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is ViewInjectionConfig", instance is ViewInjectionConfig);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", false);
		}

	}
}