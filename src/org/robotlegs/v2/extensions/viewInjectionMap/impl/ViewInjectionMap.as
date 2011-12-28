//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewInjectionMap.impl
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.extensions.viewManager.api.IViewClassInfo;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent;
	import org.robotlegs.v2.extensions.viewManager.api.ViewInterests;
	import org.robotlegs.v2.extensions.viewMap.impl.ViewMap;
	import org.swiftsuspenders.Injector;
	
	// TODO: review
	public class ViewInjectionMap extends EventDispatcher implements IViewHandler, IEventDispatcher
	{
		[Inject]
		public var injector:Injector;
		
		private var _viewMap:ViewMap;
		
		public function set viewMap(value:ViewMap):void
		{
			_viewMap = value;
			_viewMap.processCallback = processMapping;
		}

		[Event(name="configurationChange", type="org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent")]
		public function ViewInjectionMap()
		{
		}
		
		public function get interests():uint
		{
			return ViewInterests.INJECTION;
		}

		public function processView(view:DisplayObject, info:IViewClassInfo):uint
		{
			if(_viewMap.processView(view, info))
				return 1;

			return 0;
		}

		public function releaseView(view:DisplayObject):void
		{
			
		}

		public function destroy():void
		{
			
		}
		
		public function hasMapping(viewTypeOrMatcher:*):Boolean
		{
			const mapping:ViewInjectionMapping = _viewMap.getMapping(viewTypeOrMatcher) as ViewInjectionMapping;
			return (mapping && mapping.hasConfigs);
		}
		
		public function getMapping(viewTypeOrMatcher:*):ViewInjectionMapping
		{
			return _viewMap.getMapping(viewTypeOrMatcher) as ViewInjectionMapping;
		}

		public function map(viewType:Class):ViewInjectionMapping
		{
			return mapMatcher(new TypeMatcher().allOf(viewType));
		}
		
		public function mapMatcher(typeMatcher:ITypeMatcher):ViewInjectionMapping
		{
			const typeFilter:ITypeFilter = _viewMap.getOrCreateFilterForMatcher(typeMatcher);
			
			const mapping:ViewInjectionMapping = new ViewInjectionMapping(typeFilter, injector);
			
			_viewMap.createMapping(typeFilter, mapping);
			return mapping;
		}
		
		public function unmap(viewType:Class):ViewInjectionMapping
		{
			return unmapMatcher(new TypeMatcher().allOf(viewType));
		}
		
		public function unmapMatcher(typeMatcher:ITypeMatcher):ViewInjectionMapping
		{
			return _viewMap.getMapping(typeMatcher) as ViewInjectionMapping;
		}
		
		private function processMapping(view:DisplayObject, info:IViewClassInfo, filter:ITypeFilter, mapping:ViewInjectionMapping):void
		{
			_viewMap.mapViewForFilterBinding(filter, info, view);

			mapping.process(view);

			_viewMap.unmapViewForFilterBinding(filter, info, view);
		}
		
				
	}
}