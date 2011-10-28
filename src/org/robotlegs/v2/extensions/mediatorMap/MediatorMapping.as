package org.robotlegs.v2.extensions.mediatorMap
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Reflector;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.extensions.hooks.GuardsAndHooksConfig;
	import org.robotlegs.v2.extensions.hooks.IGuardsAndHooksConfig;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	
	public class MediatorMapping extends GuardsAndHooksConfig implements IMediatorMapping
	{	
		protected var _configsByFilter:Dictionary;

		protected var _filtersByDescriptor:Dictionary;
		
		protected var _mediator:Class;
						
		protected var _typeFilter:ITypeFilter;
		
		protected var _localConfigsByFilter:Dictionary;
		

		public function MediatorMapping(configsByFilter:Dictionary, filterDescriptorMap:Dictionary, mediator:Class)
		{
			_configsByFilter = configsByFilter;
			_filtersByDescriptor = filterDescriptorMap;
			_mediator = mediator;
			_localConfigsByFilter = new Dictionary();
		}
		
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
		
		public function toView(viewClazz:Class):IGuardsAndHooksConfig
		{
			return toMatcher(new TypeMatcher().allOf(viewClazz));
		}
		
		public function toMatcher(typeMatcher:ITypeMatcher):IGuardsAndHooksConfig
		{
			_typeFilter = typeMatcher.createTypeFilter();
			
			if(_filtersByDescriptor[_typeFilter.descriptor])
			{
				_typeFilter = _filtersByDescriptor[_typeFilter.descriptor];
			}
			else
			{
				_filtersByDescriptor[_typeFilter.descriptor] = _typeFilter;
				_configsByFilter[_typeFilter] = new Vector.<IMediatorConfig>();
			}
			
			const config:IMediatorConfig = new MediatorConfig(this);
			
			_configsByFilter[_typeFilter].push(config);
			_localConfigsByFilter[_typeFilter] = config;
			return config;
		}
		
		public function unmap(typeMatcher:ITypeMatcher):void
		{
			_typeFilter = typeMatcher.createTypeFilter();
			
			if(!_configsByFilter[_typeFilter] && _filtersByDescriptor[_typeFilter.descriptor])
			{
				_typeFilter = _filtersByDescriptor[_typeFilter.descriptor];
				const config:IMediatorConfig = _localConfigsByFilter[_typeFilter];
				
				const configs:Vector.<IMediatorConfig> = _configsByFilter[_typeFilter];
			
				const index:int = configs.indexOf(config);
				
				if(index > -1)
				{
					configs.splice(index, 1);
					if(configs.length==0)
					{
						delete _configsByFilter[_typeFilter];
						delete _filtersByDescriptor[_typeFilter.descriptor];
					}
				}
				
				delete _localConfigsByFilter[_typeFilter];
			}
		}
	}
}