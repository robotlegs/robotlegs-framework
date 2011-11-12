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
	import org.robotlegs.v2.core.impl.TypeMatcher;

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
		
		[Test]
		public function view_mapped_by_typeMatcher_is_injected_into():void
		{
			const injectionTracker:InjectionTracker = new InjectionTracker();
			
			injector.map(InjectionTracker).toValue(injectionTracker);
			
			instance.mapMatcher(new TypeMatcher().allOf(Sprite)).toProcess(InjectInto);
			
			const view:ViewWithInjections = new ViewWithInjections();
			
			instance.processView(view, null)
			
			assertEquals(injectionTracker, view.injectedItem);
		}
		
		[Test]
		public function view_mapped_and_unmapped_by_typeMatcher_is_not_injected_into():void
		{
			const injectionTracker:InjectionTracker = new InjectionTracker();
			
			injector.map(InjectionTracker).toValue(injectionTracker);
			
			instance.mapMatcher(new TypeMatcher().allOf(Sprite)).toProcess(InjectInto);
			instance.unmapMatcher(new TypeMatcher().allOf(Sprite)).fromProcess(InjectInto);
			
			const view:ViewWithInjections = new ViewWithInjections();
			
			instance.processView(view, null)
			
			assertEquals(null, view.injectedItem);
		}
		
		[Test]
		public function view_mapped_and_unmapped_by_viewClass_is_not_injected_into():void
		{
			const injectionTracker:InjectionTracker = new InjectionTracker();
			
			injector.map(InjectionTracker).toValue(injectionTracker);
			
			instance.map(Sprite).toProcess(InjectInto);
			instance.unmap(Sprite).fromProcess(InjectInto);
			
			const view:ViewWithInjections = new ViewWithInjections();
			
			instance.processView(view, null)
			
			assertEquals(null, view.injectedItem);
		}
		
		[Test]
		public function after_view_mapped_and_unmapped_hasMapping_is_false():void
		{
			instance.map(Sprite).toProcess(InjectInto);
			instance.unmap(Sprite).fromProcess(InjectInto);
			
			assertFalse(instance.hasMapping(Sprite));
		}
		
		[Test]
		public function after_view_mapped_hasMapping_is_true():void
		{
			instance.map(Sprite).toProcess(InjectInto);
			
			assertTrue(instance.hasMapping(Sprite));
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