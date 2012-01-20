//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.utils.Dictionary;
	import org.hamcrest.Matcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMappingConfig;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMappingFinder;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorUnmapper;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;

	public class MediatorMapper implements IMediatorMapper, IMediatorMappingFinder, IMediatorUnmapper
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Dictionary = new Dictionary();

		private var _matcher:Matcher;

		private var _handler:IMediatorViewHandler;

		private var _factory:IMediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMapper(matcher:Matcher, handler:IMediatorViewHandler, factory:IMediatorFactory)
		{
			_matcher = matcher;
			_handler = handler;
			_factory = factory;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toMediator(mediatorClass:Class):IMediatorMappingConfig
		{
			return _mappings[mediatorClass] ||= createMapping(mediatorClass);
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
			const mapping:MediatorMapping = new MediatorMapping(_matcher, mediatorClass, _factory);
			_handler.addMapping(mapping);
			return mapping;
		}
	}
}
