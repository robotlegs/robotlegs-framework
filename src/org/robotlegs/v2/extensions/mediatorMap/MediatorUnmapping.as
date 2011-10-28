package org.robotlegs.v2.extensions.mediatorMap
{
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.swiftsuspenders.Reflector;

	public class MediatorUnmapping implements IMediatorUnmapping
	{
		protected var _viewFCQNMap:Dictionary;

		protected var _typeFilterMap:Dictionary;

		protected var _mediatorClazz:Class;
		
		protected var _reflector:Reflector;
		
		protected var _typeFilter:ITypeFilter;
		
		protected var _mediatorMappings:Dictionary;

		public function MediatorUnmapping(mediatorMappings:Dictionary, viewFCQNMap:Dictionary, typeFilterMap:Dictionary, mediatorClazz:Class, reflector:Reflector)
		{
			_viewFCQNMap = viewFCQNMap;
			_typeFilterMap = typeFilterMap;
			_mediatorClazz = mediatorClazz;
			_reflector = reflector;
			_mediatorMappings = mediatorMappings;
		}

		public function fromView(viewClazz:Class):void
		{
			const fqcn:String = _reflector.getFQCN(viewClazz);
			delete _viewFCQNMap[fqcn];
			
			delete _mediatorMappings[fqcn];
		}

		public function fromMatcher(typeMatcher:ITypeMatcher):void
		{
			_typeFilter = typeMatcher.createTypeFilter();
			delete _typeFilterMap[_typeFilter];
			
			delete _mediatorMappings[_typeFilter.descriptor];
		}
	}
}