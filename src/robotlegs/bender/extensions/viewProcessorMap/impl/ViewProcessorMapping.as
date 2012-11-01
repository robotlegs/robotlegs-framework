package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMappingConfig;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.framework.impl.MappingConfigValidator;

	public class ViewProcessorMapping implements IViewProcessorMapping, IViewProcessorMappingConfig
	{
		private var _validator:MappingConfigValidator;
	
		public function ViewProcessorMapping(matcher:ITypeFilter, processor:Object)
		{
			_matcher = matcher;
			
			setProcessor(processor);
		}
	
		//---------------------------------------
		// IViewProcessorMapping Implementation
		//---------------------------------------

		private var _matcher:ITypeFilter;

		public function get matcher():ITypeFilter
		{
			return _matcher;
		}

		private var _processor:Object;

		public function get processor():Object
		{
			return _processor;
		}
		
		public function set processor(value:Object):void
		{
			_processor = value;
		}
		
		private var _processorClass:Class;
		
		public function get processorClass():Class
		{
			return _processorClass;
		}

		private var _guards:Array = [];

		public function get guards():Array
		{
			return _guards;
		}

		private var _hooks:Array = [];

		public function get hooks():Array
		{
			return _hooks;
		}

		//---------------------------------------
		// IViewProcessorMappingConfig Implementation
		//---------------------------------------

		public function withGuards(... guards):IViewProcessorMappingConfig
		{
			_validator && _validator.checkGuards(guards);
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		public function withHooks(... hooks):IViewProcessorMappingConfig
		{
			_validator && _validator.checkHooks(hooks);
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}
	
		private function setProcessor(processor:Object):void
		{
			if(processor is Class)
			{
				_processorClass = processor as Class;
			}
			else
			{
				_processor = processor;
				_processorClass = _processor.constructor;
			}
		}
		
		internal function invalidate():void
		{
			if(_validator)
				_validator.invalidate();
			else
				createValidator();

			_guards = [];
			_hooks = [];
		}
		
		public function validate():void
		{
			if(!_validator)
			{
				createValidator();
			}
			else if(!_validator.valid)
			{
				_validator.validate(_guards, _hooks);
			}
		}
		
		private function createValidator():void
		{
			const useProcessor:Object = _processor ? _processor : _processorClass;
			_validator = new MappingConfigValidator(_guards.slice(), _hooks.slice(), _matcher, useProcessor);
		}
	
	}

}