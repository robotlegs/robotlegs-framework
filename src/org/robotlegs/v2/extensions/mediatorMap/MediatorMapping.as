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
		protected var _configsByTypeFilter:Dictionary;

		protected var _filtersByDescriptor:Dictionary;
		
		protected var _mediator:Class;
								
		protected var _localConfigsByFilter:Dictionary;
		

		public function MediatorMapping(configsByTypeFilter:Dictionary, filterDescriptorMap:Dictionary, mediator:Class)
		{
			_configsByTypeFilter = configsByTypeFilter;
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
			var typeFilter:ITypeFilter = typeMatcher.createTypeFilter();
			
			if(_filtersByDescriptor[typeFilter.descriptor])
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
		
		public function unmap(typeMatcher:ITypeMatcher):void
		{
			const typeFilter:ITypeFilter = typeMatcher.createTypeFilter();
			
			unmapTypeFilter(typeFilter);
		}
		
		internal function unmapAll():void
		{
			for (var filter:* in _localConfigsByFilter)
			{
				unmapTypeFilter(filter as ITypeFilter);
			}
		}
		
		protected function unmapTypeFilter(typeFilter:ITypeFilter):void
		{			
			typeFilter = _filtersByDescriptor[typeFilter.descriptor];
			
			if(_configsByTypeFilter[typeFilter])
			{
				const config:IMediatorConfig = _localConfigsByFilter[typeFilter];
				
				const configs:Vector.<IMediatorConfig> = _configsByTypeFilter[typeFilter];
			
				const index:int = configs.indexOf(config);
				
				if(index > -1)
				{
					configs.splice(index, 1);
					if(configs.length==0)
					{
						delete _configsByTypeFilter[typeFilter];
						delete _filtersByDescriptor[typeFilter.descriptor];
					}
				}
				
				delete _localConfigsByFilter[typeFilter];
			}
		}
	}
}