//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * @private
	 */
	public class MediatorMap implements IMediatorMap, IViewHandler
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappers:Dictionary = new Dictionary();

		private var _logger:ILogger;

		private var _factory:MediatorFactory;

		private var _viewHandler:MediatorViewHandler;

		private const NULL_UNMAPPER:IMediatorUnmapper = new NullMediatorUnmapper();

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function MediatorMap(context:IContext)
		{
			_logger = context.getLogger(this);
			_factory = new MediatorFactory(context.injector);
			_viewHandler = new MediatorViewHandler(_factory);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function mapMatcher(matcher:ITypeMatcher):IMediatorMapper
		{
			return _mappers[matcher.createTypeFilter().descriptor] ||= createMapper(matcher);
		}

		/**
		 * @inheritDoc
		 */
		public function map(type:Class):IMediatorMapper
		{
			return mapMatcher(new TypeMatcher().allOf(type));
		}

		/**
		 * @inheritDoc
		 */
		public function unmapMatcher(matcher:ITypeMatcher):IMediatorUnmapper
		{
			return _mappers[matcher.createTypeFilter().descriptor] || NULL_UNMAPPER;
		}

		/**
		 * @inheritDoc
		 */
		public function unmap(type:Class):IMediatorUnmapper
		{
			return unmapMatcher(new TypeMatcher().allOf(type));
		}

		/**
		 * @inheritDoc
		 */
		public function handleView(view:DisplayObject, type:Class):void
		{
			_viewHandler.handleView(view, type);
		}

		/**
		 * @inheritDoc
		 */
		public function mediate(item:Object):void
		{
			_viewHandler.handleItem(item, item['constructor'] as Class);
		}

		/**
		 * @inheritDoc
		 */
		public function unmediate(item:Object):void
		{
			_factory.removeMediators(item);
		}

		/**
		 * @inheritDoc
		 */
		public function unmediateAll():void
		{
			_factory.removeAllMediators();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapper(matcher:ITypeMatcher):IMediatorMapper
		{
			return new MediatorMapper(matcher.createTypeFilter(), _viewHandler, _logger);
		}
	}
}
