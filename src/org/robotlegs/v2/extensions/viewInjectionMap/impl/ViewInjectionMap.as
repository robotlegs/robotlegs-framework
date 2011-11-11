//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewInjectionMap.impl
{
	import org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.api.ViewInterests;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.viewManager.api.IViewClassInfo;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import org.swiftsuspenders.Injector;
	import org.robotlegs.v2.extensions.viewMap.impl.ViewMap;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	
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

		public function map(viewType:Class):ViewInjectionMapping
		{
			const typeFilter:ITypeFilter = _viewMap.getOrCreateFilterForMatcher(new TypeMatcher().allOf(viewType));
			
			const mapping:ViewInjectionMapping = new ViewInjectionMapping(typeFilter, injector);
			
			_viewMap.createMapping(typeFilter, mapping);
			return mapping;
		}
		
		private function processMapping(view:DisplayObject, info:IViewClassInfo, filter:ITypeFilter, mapping:ViewInjectionMapping):void
		{
			trace("ViewInjectionMap::processMapping()");
			_viewMap.mapViewForFilterBinding(filter, info, view);

			mapping.process(view);

			_viewMap.unmapViewForFilterBinding(filter, info, view);
		}
		
				
	}
}