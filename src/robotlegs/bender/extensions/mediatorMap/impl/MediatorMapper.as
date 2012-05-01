//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingFinder;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.matching.ITypeFilter;

	public class MediatorMapper implements IMediatorMapper, IMediatorMappingFinder, IMediatorUnmapper
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Dictionary = new Dictionary();

		private var _matcher:ITypeFilter;

		private var _handler:IMediatorViewHandler;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMapper(matcher:ITypeFilter, handler:IMediatorViewHandler)
		{
			_matcher = matcher;
			_handler = handler;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toMediator(mediatorClass:Class):IMediatorMappingConfig
		{
			return lockedMappingFor(mediatorClass) || createMapping(mediatorClass);
		}

		public function forMediator(mediatorClass:Class):IMediatorMapping
		{
			return _mappings[mediatorClass];
		}

		public function fromMediator(mediatorClass:Class):void
		{
			const mapping:IMediatorMapping = _mappings[mediatorClass];
			delete _mappings[mediatorClass];
			_handler.removeMapping(mapping);
		}

		public function fromMediators():void
		{
			for each (var mapping:IMediatorMapping in _mappings)
			{
				delete _mappings[mapping.mediatorClass];
				_handler.removeMapping(mapping);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapping(mediatorClass:Class):MediatorMapping
		{
			const mapping:MediatorMapping = new MediatorMapping(_matcher, mediatorClass);
			_handler.addMapping(mapping);
			_mappings[mediatorClass] = mapping;
			return mapping;
		}
		
		private function lockedMappingFor(mediatorClass:Class):MediatorMapping
		{
			const mapping:MediatorMapping = _mappings[mediatorClass];
			if(mapping)
				mapping.invalidate();

			return mapping;
		}
	}
}