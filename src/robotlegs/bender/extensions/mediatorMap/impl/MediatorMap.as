//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import org.hamcrest.Matcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorManager;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMappingFinder;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorUnmapper;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;

	public class MediatorMap implements IMediatorMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappers:Dictionary = new Dictionary();

		private const _handler:IMediatorViewHandler = new MediatorViewHandler();

		private var _manager:IMediatorManager;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMap(manager:IMediatorManager)
		{
			_manager = manager;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(matcher:Matcher):IMediatorMapper
		{
			return _mappers[String(matcher)] ||= createMapper(matcher);
		}

		public function getMapping(matcher:Matcher):IMediatorMappingFinder
		{
			return _mappers[String(matcher)];
		}

		public function unmap(matcher:Matcher):IMediatorUnmapper
		{
			return _mappers[String(matcher)];
		}

		public function handleView(view:DisplayObject, type:Class):void
		{
			_handler.handleView(view, type);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapper(matcher:Matcher):IMediatorMapper
		{
			return new MediatorMapper(matcher, _handler, _manager);
		}
	}
}
