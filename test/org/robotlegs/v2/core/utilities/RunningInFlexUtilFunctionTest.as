//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.utilities
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.impl.support.*;
	import org.robotlegs.v2.core.utilities.checkUIComponentAvailable;
	//import mx.core.UIComponent;

	public class RunningInFlexUtilFunctionTest
	{
		// without this, we can't guarantee its availability
		// if flex isn't present then we'll get a compiler error not a test fail
		//private const uiComponentImporter:UIComponent = new UIComponent();
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function returns_true_when_UIComponent_present():void
		{
			assertTrue(checkUIComponentAvailable());
		}
	}
}