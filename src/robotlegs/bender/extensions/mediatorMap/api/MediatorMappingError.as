package robotlegs.bender.extensions.mediatorMap.api
{
	import robotlegs.bender.extensions.matching.ITypeFilter;

	public class MediatorMappingError extends Error
	{
	
		public function MediatorMappingError(message:String, typeFilter:ITypeFilter, mediatorClass:Class)
		{
			super(message);
			_typeFilter = typeFilter;
			_mediatorClass = mediatorClass;
		}

		private var _typeFilter:ITypeFilter;

		public function get typeFilter():ITypeFilter
		{
			return _typeFilter;
		}
		
		private var _mediatorClass:Class;

		public function get mediatorClass():Class
		{
			return _mediatorClass;
		}
	}
}