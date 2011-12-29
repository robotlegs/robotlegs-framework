//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewMap.impl
{
	import org.flexunit.asserts.*;
	import robotlegs.bender.extensions.viewManager.impl.ViewClassInfo;
	import robotlegs.bender.core.impl.TypeMatcher;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.InteractiveObject;
	import org.flexunit.assertThat;
	import org.hamcrest.object.hasProperties;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.core.api.ITypeFilter;
	import robotlegs.bender.core.api.ITypeMatcher;
	import robotlegs.bender.core.impl.PackageMatcher;
	import flash.display.DisplayObject;

	public class ViewMapTest
	{
		private var instance:ViewMap;
		private var injector:Injector;

		private var viewReceived:*;
		private var mappingReceived:*;

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

		[Test]
		public function handles_mapping_by_packageFilter():void
		{
			viewReceived = null;
			mappingReceived = null;

			const packageMatcher:PackageMatcher = new PackageMatcher().require('flash.display');
			const expectedMapping:Object = {};
			expectedMapping.hasConfigs = true;
			const expectedView:Sprite = new Sprite();
			const viewClassInfo:ViewClassInfo = new ViewClassInfo(Sprite, 'flash.display.Sprite', null);

			instance.processCallback = handleView;

			instance.createMapping(packageMatcher.createTypeFilter(), expectedMapping);

			instance.processView(expectedView, viewClassInfo)

			assertEquals(expectedView, viewReceived);
			assertEquals(expectedMapping, mappingReceived);
		}

		protected function handleView(view:DisplayObject, info:ViewClassInfo, filter:ITypeFilter, mapping:*):void
		{
			viewReceived = view;
			mappingReceived = mapping;
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