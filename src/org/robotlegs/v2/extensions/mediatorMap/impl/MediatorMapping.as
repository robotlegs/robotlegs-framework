//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.extensions.hooks.GuardsAndHooksConfig;
	import org.robotlegs.v2.extensions.hooks.IGuardsAndHooksConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMapping;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorUnmapping;
	import org.swiftsuspenders.Reflector;

	public class MediatorMapping extends GuardsAndHooksConfig implements IMediatorMapping, IMediatorUnmapping
	{

		protected var _mediator:Class;

		public function get mediator():Class
		{
			return _mediator;
		}

		protected var _callbackForDeletion:Function;

		protected var _configsByTypeFilter:Dictionary;

		protected var _filtersByDescriptor:Dictionary;

		protected const _localConfigsByFilter:Dictionary = new Dictionary();

		internal function get hasConfigs():Boolean
		{
			for each (var item:Object in _localConfigsByFilter)
			{
				return true;
			}

			return false;
		}

		public function MediatorMapping(configsByTypeFilter:Dictionary, filterDescriptorMap:Dictionary,
			mediator:Class, callbackForDeletion:Function)
		{
			_configsByTypeFilter = configsByTypeFilter;
			_filtersByDescriptor = filterDescriptorMap;
			_mediator = mediator;
			_callbackForDeletion = callbackForDeletion;
		}

		public function toMatcher(typeMatcher:ITypeMatcher):IGuardsAndHooksConfig
		{
			var typeFilter:ITypeFilter = typeMatcher.createTypeFilter();

			if (_filtersByDescriptor[typeFilter.descriptor])
			{
				typeFilter = _filtersByDescriptor[typeFilter.descriptor];
			}
			else
			{
				_filtersByDescriptor[typeFilter.descriptor] = typeFilter;
				_configsByTypeFilter[typeFilter] = new Vector.<IMediatorConfig>();
			}

			const config:IMediatorConfig = new MediatorConfig(this);

			_configsByTypeFilter[typeFilter].push(config);
			_localConfigsByFilter[typeFilter] = config;
			return config;
		}

		public function toView(viewType:Class):IGuardsAndHooksConfig
		{
			return toMatcher(new TypeMatcher().allOf(viewType));
		}

		public function fromMatcher(typeMatcher:ITypeMatcher):void
		{
			const typeFilter:ITypeFilter = typeMatcher.createTypeFilter();

			unmapTypeFilter(typeFilter);
		}

		public function fromView(viewType:Class):void
		{
			fromMatcher(new TypeMatcher().allOf(viewType));
		}

		public function fromAll():void
		{
			for (var filter:* in _localConfigsByFilter)
			{
				unmapTypeFilter(filter as ITypeFilter);
			}
		}

		protected function unmapTypeFilter(typeFilter:ITypeFilter):void
		{
			typeFilter = _filtersByDescriptor[typeFilter.descriptor];

			if (_configsByTypeFilter[typeFilter])
			{
				const config:IMediatorConfig = _localConfigsByFilter[typeFilter];

				const configs:Vector.<IMediatorConfig> = _configsByTypeFilter[typeFilter];

				const index:int = configs.indexOf(config);

				if (index > -1)
				{
					configs.splice(index, 1);
					if (configs.length == 0)
					{
						delete _configsByTypeFilter[typeFilter];
						delete _filtersByDescriptor[typeFilter.descriptor];
					}
				}

				delete _localConfigsByFilter[typeFilter];
			}

			if (!hasConfigs)
			{
				_callbackForDeletion(_mediator);
			}
		}
	}
}
