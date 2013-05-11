//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMappingConfig;

	/**
	 * @private
	 */
	public class ViewProcessorMapping implements IViewProcessorMapping, IViewProcessorMappingConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _matcher:ITypeFilter;

		/**
		 * @inheritDoc
		 */
		public function get matcher():ITypeFilter
		{
			return _matcher;
		}

		private var _processor:Object;

		/**
		 * @inheritDoc
		 */
		public function get processor():Object
		{
			return _processor;
		}

		/**
		 * @inheritDoc
		 */
		public function set processor(value:Object):void
		{
			_processor = value;
		}

		private var _processorClass:Class;

		/**
		 * @inheritDoc
		 */
		public function get processorClass():Class
		{
			return _processorClass;
		}

		private var _guards:Array = [];

		/**
		 * @inheritDoc
		 */
		public function get guards():Array
		{
			return _guards;
		}

		private var _hooks:Array = [];

		/**
		 * @inheritDoc
		 */
		public function get hooks():Array
		{
			return _hooks;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function ViewProcessorMapping(matcher:ITypeFilter, processor:Object)
		{
			_matcher = matcher;

			setProcessor(processor);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function withGuards(... guards):IViewProcessorMappingConfig
		{
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withHooks(... hooks):IViewProcessorMappingConfig
		{
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}

		public function toString():String
		{
			return 'Processor ' + _processor;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function setProcessor(processor:Object):void
		{
			if (processor is Class)
			{
				_processorClass = processor as Class;
			}
			else
			{
				_processor = processor;
				_processorClass = _processor.constructor;
			}
		}
	}

}
