package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapper;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMappingConfig;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorUnmapper;
	import robotlegs.bender.extensions.viewProcessorMap.impl.IViewProcessorViewHandler;

	public class ViewProcessorMapper implements IViewProcessorMapper, IViewProcessorUnmapper
	{
		private var _handler:IViewProcessorViewHandler;
	
		private var _matcher:ITypeFilter;
		
		private const _mappings:Dictionary = new Dictionary();
	
		public function ViewProcessorMapper(matcher:ITypeFilter, handler:IViewProcessorViewHandler)
		{
			_handler = handler;
			_matcher = matcher;
		}
		
		//---------------------------------------
		// IViewProcessorMapper Implementation
		//---------------------------------------

		public function toProcess(processClassOrInstance:*):IViewProcessorMappingConfig
		{
			return lockedMappingFor(processClassOrInstance) || createMapping(processClassOrInstance);
		}

		public function toInjection():IViewProcessorMappingConfig
		{
			return toProcess(ViewInjectionProcessor);
		}

		public function toNoProcess():IViewProcessorMappingConfig
		{
			return toProcess(NullProcessor);
		}

		//---------------------------------------
		// IViewProcessorUnmapper Implementation
		//---------------------------------------

		public function fromProcess(processorClassOrInstance:*):void
		{
			const mapping:IViewProcessorMapping = _mappings[processorClassOrInstance];
			delete _mappings[processorClassOrInstance];
			_handler.removeMapping(mapping);
		}

		public function fromProcesses():void
		{
			for(var processor:Object in _mappings)
			{
				fromProcess(processor);
			}
		}

		public function fromNoProcess():void
		{
			fromProcess(NullProcessor);
		}

		public function fromInjection():void
		{
			fromProcess(ViewInjectionProcessor);
		}
		
		private function createMapping(processor:Object):ViewProcessorMapping
		{
			const mapping:ViewProcessorMapping = new ViewProcessorMapping(_matcher, processor);
			_handler.addMapping(mapping);
			_mappings[processor] = mapping;
			return mapping;
		}

		private function lockedMappingFor(processorClassOrInstance:*):ViewProcessorMapping
		{
			const mapping:ViewProcessorMapping = _mappings[processorClassOrInstance];
			if(mapping)
				mapping.invalidate();

			return mapping;
		}
	}
}