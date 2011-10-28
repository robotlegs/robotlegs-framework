package org.robotlegs.v2.extensions.mediatorMap
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Reflector;
	
	public class MediatorMappingBinding
	{	
		protected var _viewFCQNMap:Dictionary;

		protected var _mediatorClazz:Class;
		
		protected var _viewClazz:Class;
		
		protected var _reflector:Reflector;

		public function MediatorMappingBinding(viewFCQNMap:Dictionary, mediatorClazz:Class, reflector:Reflector)
		{
			_viewFCQNMap = viewFCQNMap;
			_mediatorClazz = mediatorClazz;
			_reflector = reflector;
		}

		public function get mediatorClass():Class
		{
			return _mediatorClazz;
		}
		
		public function get viewClass():Class
		{
			return _viewClazz;
		}

		public function toView(viewClazz:Class):MediatorMappingBinding
		{
			const fqcn:String = _reflector.getFQCN(viewClazz);
			_viewFCQNMap[fqcn] = this;
			_viewClazz = viewClazz;
			
			return this;
		}
	}
}