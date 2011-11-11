//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewMap.impl 
{
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewClassInfo;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.InteractiveObject;
	import org.flexunit.assertThat;
	import org.hamcrest.object.hasProperties;
	import org.swiftsuspenders.Injector;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.api.ITypeMatcher;

	public class ViewMapTest 
	{
		private var instance:ViewMap;
		private var injector:Injector;

		[Before]
		public function setUp():void
		{
			instance = new ViewMap();
			injector = new Injector();
			instance.injector = injector;
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
			assertTrue("instance is ViewMap", instance is ViewMap);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function maps_view_as_actual_type_as_well_as_filter_types():void
		{
			const viewClassInfo:ViewClassInfo = new ViewClassInfo(MovieClip, 'flash.display.MovieClip', null);
			const typeMatcher:ITypeMatcher = new TypeMatcher().allOf(InteractiveObject).anyOf(Sprite, TextField);
			
			const typeFilter:ITypeFilter = typeMatcher.createTypeFilter();
			
			const view:MovieClip = new MovieClip();
			
			instance.mapViewForFilterBinding(typeFilter, viewClassInfo, view);
			
			const injectedClass:GreedyClassNeedingViewInjections = injector.getInstance(GreedyClassNeedingViewInjections);
			
			assertThat(injectedClass, hasProperties({ 	"interactiveObject" : view,
														"sprite" : view,
														"movieClip" : view  }))
		}
	}
}

import flash.display.MovieClip;
import flash.text.TextField;
import flash.display.Sprite;
import flash.display.InteractiveObject;

class GreedyClassNeedingViewInjections
{
	[Inject]
	public var interactiveObject:InteractiveObject;
	
	[Inject]
	public var sprite:Sprite;
	
	[Inject]
	public var movieClip:MovieClip;
}