package robotlegs.bender.extensions.viewProcessorMap.api
{
	import robotlegs.bender.extensions.matching.ITypeFilter;

	public class ViewProcessorMappingError extends Error
	{
		public function ViewProcessorMappingError(message:String, typeFilter:ITypeFilter, processor:Object)
		{
			super(message);
			_typeFilter = typeFilter;
			_processor = processor;
		}

		private var _typeFilter:ITypeFilter;

		public function get typeFilter():ITypeFilter
		{
			return _typeFilter;
		}
		
		private var _processor:Object;

		public function get processor():Object
		{
			return _processor;
		}
	}
}