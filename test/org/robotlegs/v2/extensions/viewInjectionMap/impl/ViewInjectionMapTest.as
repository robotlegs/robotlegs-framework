//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewInjectionMap.impl 
{
	import org.flexunit.asserts.*;
	import org.swiftsuspenders.Injector;
	import flash.display.Sprite;
	import org.robotlegs.v2.extensions.viewInjectionMap.impl.processors.InjectInto;
	import org.robotlegs.v2.extensions.viewMap.impl.ViewMap;

	public class ViewInjectionMapTest 
	{
		private var instance:ViewInjectionMap;
		private var injector:Injector;

		[Before]
		public function setUp():void
		{
			instance = new ViewInjectionMap();
			injector = new Injector();
			instance.injector = injector;
			const viewMap:ViewMap = new ViewMap();
			viewMap.injector = injector;
			instance.viewMap = viewMap;
			injector.map(Injector).toValue(injector);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			injector = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is ViewInjectionMap", instance is ViewInjectionMap);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function view_is_injected_into():void
		{
			const injectionTracker:InjectionTracker = new InjectionTracker();
			
			injector.map(InjectionTracker).toValue(injectionTracker);
			
			instance.map(Sprite).toProcess(InjectInto);
			
			const view:ViewWithInjections = new ViewWithInjections();
			
			instance.processView(view, null)
			
			assertEquals(injectionTracker, view.injectedItem);
		}

	}
}

import flash.display.Sprite;

class ViewWithInjections extends Sprite
{
	[Inject]
	public var injectedItem:InjectionTracker;
}

class InjectionTracker
{
	
}