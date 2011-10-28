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
	import org.swiftsuspenders.Reflector;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMapping;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorConfig;

	public class MediatorMapping extends GuardsAndHooksConfig implements IMediatorMapping
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _mediator:Class;

		/*
		 function toMatcher(matcher):MediatorConfig
		 function toView(type):MediatorConfig // this is just sugar
		 function get mediator():Class
		 function hasConfigFor(matcher):Boolean
		 function getConfigFor(matcher):MediatorConfig
		 function unmap(matcher):MediatorConfig
		*/

		public function get mediator():Class
		{
			return _mediator;
		}

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _configsByTypeFilter:Dictionary;

		protected var _filtersByDescriptor:Dictionary;

		protected var _localConfigsByFilter:Dictionary;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMapping(configsByTypeFilter:Dictionary, filterDescriptorMap:Dictionary, mediator:Class)
		{
			_configsByTypeFilter = configsByTypeFilter;
			_filtersByDescriptor = filterDescriptorMap;
			_mediator = mediator;
			_localConfigsByFilter = new Dictionary();
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

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

		public function toView(viewClazz:Class):IGuardsAndHooksConfig
		{
			return toMatcher(new TypeMatcher().allOf(viewClazz));
		}

		public function unmap(typeMatcher:ITypeMatcher):void
		{
			const typeFilter:ITypeFilter = typeMatcher.createTypeFilter();

			unmapTypeFilter(typeFilter);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

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
		}

		/*============================================================================*/
		/* Internal Functions                                                         */
		/*============================================================================*/

		internal function unmapAll():void
		{
			for (var filter:* in _localConfigsByFilter)
			{
				unmapTypeFilter(filter as ITypeFilter);
			}
		}
	}
}