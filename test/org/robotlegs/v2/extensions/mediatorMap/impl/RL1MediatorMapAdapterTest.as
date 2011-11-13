//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl 
{
	import org.flexunit.asserts.*;

	public class RL1MediatorMapAdapterTest 
	{
		private var instance:RL1MediatorMapAdapter;

		[Before]
		public function setUp():void
		{
			instance = new RL1MediatorMapAdapter();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is RL1MediatorMapAdapter", instance is RL1MediatorMapAdapter);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", false);
		}

	}
}