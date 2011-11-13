//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewMap.impl
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.extensions.viewManager.api.IViewClassInfo;
	import org.swiftsuspenders.Injector;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewClassInfo;

	public class ViewMap
	{
		[Inject]
		public var injector:Injector;

		private const _filtersByDescription:Dictionary = new Dictionary();

		private const _mappingsByTypeFilter:Dictionary = new Dictionary();
		
		private var _processCallback:Function;
		
		public function set processCallback(value:Function):void
		{
			_processCallback = value;
		}

		public function processView(view:DisplayObject, info:IViewClassInfo):Boolean
		{
			// TODO - temporary workaround as the viewManager doesn't currently provide this info
			if(info == null)
			{
				info = createViewClassInfo(view);
			}
			
			var interested:Boolean = false;

			for (var filter:* in _mappingsByTypeFilter)
			{				
				if ((filter as ITypeFilter).matches(view)  && (_mappingsByTypeFilter[filter].hasConfigs))
				{
					interested = true;

					_processCallback(view, info, filter, _mappingsByTypeFilter[filter]);
				}
			}

			return interested;
		}

		public function getMapping(viewTypeOrMatcher:*):Object
		{
			if(viewTypeOrMatcher is Class)
			{
				viewTypeOrMatcher = new TypeMatcher().allOf(viewTypeOrMatcher);
			}
			
			const typeFilter:ITypeFilter = getOrCreateFilterForMatcher(viewTypeOrMatcher as ITypeMatcher);
			return _mappingsByTypeFilter[typeFilter];
		}
		
		public function hasMapping(viewTypeOrMatcher:*):Boolean
		{
			return (getMapping(viewTypeOrMatcher) != null);
		}

		public function createMapping(typeFilter:ITypeFilter, mapping:Object):void
		{
			_mappingsByTypeFilter[typeFilter] = mapping;
		}

		public function removeMapping(typeFilter:ITypeFilter):void
		{
			delete _mappingsByTypeFilter[typeFilter];
		}
		
		public function cleanUpMapping(typeFilter:ITypeFilter):void
		{
			delete _mappingsByTypeFilter[typeFilter];
		}
		
		public function getOrCreateFilterForMatcher(typeMatcher:ITypeMatcher):ITypeFilter
		{
			const typeFilter:ITypeFilter = typeMatcher.createTypeFilter();
			const descriptor:String = typeFilter.descriptor;
			
			if(_filtersByDescription[descriptor])
			{
				return _filtersByDescription[descriptor];
			}
			
			_filtersByDescription[descriptor] = typeFilter;
			return typeFilter;
		}
		
		public function mapViewForFilterBinding(filter:ITypeFilter, info:IViewClassInfo, view:DisplayObject):void
		{
			var requiredType:Class;
			const requiredTypes:Vector.<Class> = filter.allOfTypes.concat(filter.anyOfTypes);
			
			if(requiredTypes.indexOf(info.type) == -1)
			{
				requiredTypes.push(info.type);
			}

			for each (requiredType in requiredTypes)
			{
				injector.map(requiredType).toValue(view);
			}
		}

		public function unmapViewForFilterBinding(filter:ITypeFilter, info:IViewClassInfo, view:DisplayObject):void
		{
			var requiredType:Class;
			const requiredTypes:Vector.<Class> = filter.allOfTypes.concat(filter.anyOfTypes);
			
			if(requiredTypes.indexOf(info.type) == -1)
			{
				requiredTypes.push(info.type);
			}

			for each (requiredType in requiredTypes)
			{
				if(injector.map(requiredType))
					injector.unmap(requiredType);
			}
		}
		
		private function createViewClassInfo(view:DisplayObject):ViewClassInfo
		{
			const type:Class = view['constructor'];
			const fcqn:String = getQualifiedClassName(view);
			return new ViewClassInfo(type, fcqn, null);
		}
	}
}